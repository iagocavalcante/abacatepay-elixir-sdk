defmodule AbacatepayElixirSdk.CouponClient do
  @moduledoc """
  V1 discount coupons. For v2, see `AbacatepayElixirSdk.V2.Coupons`.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Coupon

  @doc """
  Create a v1 coupon. Percentage discounts use hundredths of a percentage point.

      alias AbacatepayElixirSdk.CouponClient

      CouponClient.create(%{
        code: "GUIDE10",
        discountKind: "PERCENTAGE",
        discount: 1000,
        notes: "10% off the guide"
      })
  """
  @spec create(map()) :: {:ok, Coupon.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/coupon/create", json: params)
    |> Response.parse(struct: Coupon)
  end

  @doc "List v1 coupons as `AbacatepayElixirSdk.Coupon` structs."
  @spec list() :: {:ok, [Coupon.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/coupon/list")
    |> Response.parse(struct: Coupon)
  end
end
