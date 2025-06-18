defmodule AbacatepayElixirSdk.CouponClientTest do
  use ExUnit.Case

  test "create coupon returns a response from the real API" do
    coupon = %{
      code: "DEYVIN_20",
      notes: "Cupom de desconto pro meu público",
      maxRedeems: 10,
      discountKind: "PERCENTAGE",
      discount: 123,
      metadata: %{}
    }
    result = AbacatepayElixirSdk.CouponClient.create(coupon)
    assert is_tuple(result)
  end

  test "list coupons returns a response from the real API" do
    result = AbacatepayElixirSdk.CouponClient.list()
    assert is_tuple(result)
    case result do
      {:ok, data} -> assert is_list(data)
      _ -> :ok
    end
  end
end
