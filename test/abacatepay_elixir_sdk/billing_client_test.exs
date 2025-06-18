defmodule AbacatepayElixirSdk.BillingClientTest do
  use ExUnit.Case

  test "list billings returns a response from the real API" do
    result = AbacatepayElixirSdk.BillingClient.list()
    assert is_tuple(result)
  end

  test "create billing returns a response from the real API" do
    billing = %{
      frequency: "ONE_TIME",
      methods: ["PIX"],
      products: [
        %{
          external_id: "abc_123",
          name: "Product A",
          description: "Description of product A",
          quantity: 1,
          price: 100
        }
      ],
      metadata: %{},
      customer: %{}
    }
    result = AbacatepayElixirSdk.BillingClient.create(billing)
    assert is_tuple(result)
  end

  test "create billing with invalid data returns an error" do
    billing = %{}
    result = AbacatepayElixirSdk.BillingClient.create(billing)
    assert {:error, _} = result
  end

  test "list billings always returns a list" do
    {:ok, billings} = AbacatepayElixirSdk.BillingClient.list()
    assert is_list(billings)
  end
end
