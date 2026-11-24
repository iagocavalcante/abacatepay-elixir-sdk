defmodule AbacatepayElixirSdk.V2Test do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.{Error, V2}

  setup do
    for {key, value} <- [v2_api_token: "test-v2", public_mrr_token: "mrr_test"] do
      previous = Application.fetch_env(:abacatepay_elixir_sdk, key)
      Application.put_env(:abacatepay_elixir_sdk, key, value)

      on_exit(fn ->
        case previous do
          {:ok, value} -> Application.put_env(:abacatepay_elixir_sdk, key, value)
          :error -> Application.delete_env(:abacatepay_elixir_sdk, key)
        end
      end)
    end

    options = Req.default_options()
    on_exit(fn -> Req.default_options(options) end)
  end

  test "creates a catalog product and uses its ID in a hosted checkout" do
    use_cassette "v2_hosted_checkout", match_requests_on: [:request_body], strict_mode: true do
      product = %{externalId: "guide", name: "Guide", price: 1999, currency: "BRL"}
      assert {:ok, %{"data" => %{"id" => id}}} = V2.Products.create(product)

      assert {:ok, %{"data" => %{"url" => "https://example.com/pay/bill_test"}}} =
               V2.Checkouts.create(%{items: [%{id: id, quantity: 1}], methods: ["PIX"]})
    end
  end

  test "sends the v2 transparent charge shape and authenticates with the v2 key" do
    charge = %{"method" => "PIX", "data" => %{"amount" => 1999, "coupon" => "GUIDE10"}}
    stub(200, %{"success" => true, "data" => %{"brCode" => "pix-code"}})

    assert {:ok, %{"data" => %{"brCode" => "pix-code"}}} = V2.Transparents.create(charge)
    assert_received {:request, req}
    assert req.method == :post
    assert URI.to_string(req.url) == "https://api.abacatepay.com/v2/transparents/create"
    assert Req.Request.get_header(req, "authorization") == ["Bearer test-v2"]
    assert Jason.decode!(req.body) == charge
  end

  test "quotes transparent card installments before charging" do
    stub(200, %{"success" => true, "data" => %{"installments" => [%{"total" => 2100}]}})

    assert {:ok, %{"data" => %{"installments" => [_]}}} =
             V2.Transparents.quote(%{"amount" => 1999, "passFeesToCustomer" => true})

    assert_received {:request, req}
    assert req.method == :get
    assert req.url.path == "/v2/transparents/quote"

    assert URI.decode_query(req.url.query) == %{
             "amount" => "1999",
             "passFeesToCustomer" => "true"
           }
  end

  test "preserves pagination cursors and encodes filters" do
    page = %{"next" => "a+b/c", "before" => nil, "hasMore" => true}
    stub(200, %{"success" => true, "data" => [], "pagination" => page})

    assert {:ok, %{"data" => [], "pagination" => ^page}} = V2.Customers.list()
    assert_received {:request, first}
    assert first.method == :get
    assert first.url.path == "/v2/customers/list"
    assert first.url.query == nil
    assert {:ok, _} = V2.Customers.list(after: page["next"], limit: 20)
    assert_received {:request, second}
    assert URI.decode_query(second.url.query) == %{"after" => "a+b/c", "limit" => "20"}
  end

  test "places action IDs in the documented query or JSON body" do
    stub(200, %{"success" => true, "error" => nil})
    assert {:ok, %{"success" => true}} = V2.Webhooks.delete("webh_123")
    assert_received {:request, delete}
    assert delete.method == :post
    assert delete.url.path == "/v2/webhooks/delete"
    assert delete.url.query == "id=webh_123"
    assert delete.body in [nil, ""]

    assert {:ok, _} = V2.Coupons.toggle("SUMMER")
    assert_received {:request, toggle}
    assert toggle.method == :post
    assert toggle.url.path == "/v2/coupons/toggle"
    assert toggle.url.query == nil
    assert Jason.decode!(toggle.body) == %{"id" => "SUMMER"}
  end

  test "routes payouts to the store owner separately from PIX transfers to third parties" do
    payout = %{
      "amount" => 10000,
      "externalId" => "payout-1",
      "pix" => %{"type" => "CNPJ", "key" => "11222333000181"}
    }

    transfer = %{
      "amount" => 1500,
      "externalId" => "transfer-1",
      "pix" => %{"type" => "EMAIL", "key" => "seller@example.com"}
    }

    stub(200, %{"success" => true})

    assert {:ok, _} = V2.Payouts.create(payout)
    assert_received {:request, req}
    assert req.method == :post and req.url.path == "/v2/payouts/create"
    assert Jason.decode!(req.body) == payout

    assert {:ok, _} = V2.Pix.send(transfer)
    assert_received {:request, req}
    assert req.method == :post and req.url.path == "/v2/pix/send"
    assert Jason.decode!(req.body) == transfer
  end

  test "uses the MRR plugin token for dated revenue queries" do
    stub(200, %{"success" => true, "data" => %{"totalRevenue" => 1999}})
    assert {:ok, _} = V2.PublicMrr.revenue("2026-11-01", "2026-11-02")
    assert_received {:request, req}
    assert Req.Request.get_header(req, "authorization") == ["Bearer mrr_test"]
    assert req.url.path == "/v2/public-mrr/revenue"

    assert URI.decode_query(req.url.query) == %{
             "startDate" => "2026-11-01",
             "endDate" => "2026-11-02"
           }
  end

  test "returns a configuration error before sending a request with the wrong key" do
    stub(200, %{"success" => true})
    Application.delete_env(:abacatepay_elixir_sdk, :public_mrr_token)
    assert {:error, %Error{code: "MISSING_TOKEN"}} = V2.PublicMrr.mrr()

    Application.delete_env(:abacatepay_elixir_sdk, :v2_api_token)
    assert {:error, %Error{code: "MISSING_TOKEN"}} = V2.Stores.get()
    refute_received {:request, _}
  end

  test "converts HTTP, envelope and non-JSON errors into SDK errors" do
    for status <- [200, 401, 422, 429] do
      stub(status, %{"success" => false, "error" => "request rejected", "data" => nil})
      assert {:error, %Error{status: ^status, message: "request rejected"}} = V2.Stores.get()
    end

    stub(502, "Bad Gateway")

    assert {:error, %Error{status: 502, message: "Unexpected response from AbacatePay"}} =
             V2.Stores.get()
  end

  test "reports transport errors" do
    Req.default_options(
      adapter: fn req -> {req, %Req.TransportError{reason: :timeout}} end,
      retry: false
    )

    assert {:error, %Error{code: "NETWORK_ERROR", message: "timeout"}} = V2.Stores.get()
  end

  defp stub(status, body) do
    Req.default_options(
      retry: false,
      adapter: fn req ->
        send(self(), {:request, req})
        {req, Req.Response.new(status: status, body: body)}
      end
    )
  end
end
