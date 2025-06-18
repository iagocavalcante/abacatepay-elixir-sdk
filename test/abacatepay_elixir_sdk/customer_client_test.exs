defmodule AbacatepayElixirSdk.CustomerClientTest do
  use ExUnit.Case

  test "create customer returns a response from the real API" do
    customer = %{
      name: "Daniel Lima",
      cellphone: "(11) 4002-8922",
      email: "daniel_lima@abacatepay.com",
      taxId: "123.456.789-01"
    }
    result = AbacatepayElixirSdk.CustomerClient.create(customer)
    assert is_tuple(result)
  end

  test "create customer with invalid data returns an error" do
    customer = %{}
    result = AbacatepayElixirSdk.CustomerClient.create(customer)
    assert {:error, _} = result
  end
end
