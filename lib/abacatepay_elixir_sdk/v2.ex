defmodule AbacatepayElixirSdk.V2 do
  @moduledoc """
  AbacatePay API v2. Use the resource modules under this namespace.

      alias AbacatepayElixirSdk.V2.{Checkouts, Products}

      {:ok, %{"data" => product}} =
        Products.create(%{externalId: "guide", name: "Guide", price: 1999, currency: "BRL"})

      {:ok, %{"data" => %{"url" => url}}} =
        Checkouts.create(%{items: [%{id: product["id"], quantity: 1}]})

  Set `:v2_api_token` in the `:abacatepay_elixir_sdk` application configuration.
  Public MRR uses its own `:public_mrr_token`. The API key selects test or production.
  You can override the v2 server URL with `:v2_base_url`.

  Pass the API's camelCase field names in JSON maps and query parameters. Successful
  calls return the decoded JSON envelope with string keys, including `"pagination"`
  when the endpoint provides it. Failures return `{:error, %AbacatepayElixirSdk.Error{}}`.

  ## Resources

  * Hosted payments — `AbacatepayElixirSdk.V2.Checkouts` and `AbacatepayElixirSdk.V2.PaymentLinks`
  * Embedded PIX, boleto and card charges — `AbacatepayElixirSdk.V2.Transparents`
  * Recurring billing — `AbacatepayElixirSdk.V2.Subscriptions` and `AbacatepayElixirSdk.V2.CustomerPortal`
  * Catalog and buyers — `AbacatepayElixirSdk.V2.Products`, `AbacatepayElixirSdk.V2.Coupons` and `AbacatepayElixirSdk.V2.Customers`
  * Outbound funds — `AbacatepayElixirSdk.V2.Payouts`, `AbacatepayElixirSdk.V2.Pix` and `AbacatepayElixirSdk.V2.SubAccounts`
  * Store balances and activity — `AbacatepayElixirSdk.V2.Stores` and `AbacatepayElixirSdk.V2.BankStatement`
  * Integrations — `AbacatepayElixirSdk.V2.PublicMrr` and `AbacatepayElixirSdk.V2.Webhooks`

  [AbacatePay API reference](https://docs.abacatepay.com/pages/reference/introduction)
  """

  alias AbacatepayElixirSdk.{Error, HttpClient}

  @base_url "https://api.abacatepay.com/v2"

  @type result :: {:ok, map()} | {:error, Error.t()}
  @type query :: keyword() | map()

  @doc false
  @spec request(:get | :post, String.t(), keyword()) :: result()
  def request(method, path, opts \\ []) do
    key = token_key(path)

    case Application.get_env(:abacatepay_elixir_sdk, key) do
      token when is_binary(token) and token != "" ->
        url = Application.get_env(:abacatepay_elixir_sdk, :v2_base_url, @base_url)

        HttpClient.request(method, path, [api_token: token, base_url: url] ++ opts)
        |> parse()

      _ ->
        {:error,
         %Error{code: "MISSING_TOKEN", message: "Configure #{inspect(key)} for AbacatePay v2"}}
    end
  end

  defp token_key("/public-mrr/" <> _), do: :public_mrr_token
  defp token_key(_), do: :v2_api_token

  defp parse({:ok, %{status: status, body: %{"success" => true} = envelope}})
       when status in 200..299, do: {:ok, envelope}

  defp parse({:ok, %{status: status, body: body}}),
    do: {:error, Error.from_response(body, status)}

  defp parse({:error, error}), do: {:error, Error.from_exception(error)}
end
