defmodule AbacatepayElixirSdk.CouponClient do
  @moduledoc """
  Client for Coupon operations.

  Provides functions to create and list discount coupons.

  ## Examples

      # Create a coupon
      params = %{code: "SAVE20", discount: 20, discount_type: "PERCENTAGE"}
      {:ok, %Coupon{} = coupon} = CouponClient.create(params)

      # List all coupons
      {:ok, coupons} = CouponClient.list()
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Coupon

  @doc """
  Creates a new coupon.

  ## Parameters

    * `params` - Map with the following keys:
      * `:code` (required) - Coupon code
      * `:discount` (required) - Discount value
      * `:discount_type` (required) - Type ("PERCENTAGE" or "FIXED")
      * `:max_uses` (optional) - Maximum number of uses
      * `:expires_at` (optional) - Expiration timestamp

  ## Returns

    * `{:ok, %Coupon{}}` - The created coupon
    * `{:error, %Error{}}` - Error details

  ## Examples

      params = %{
        code: "SUMMER2024",
        discount: 15,
        discount_type: "PERCENTAGE",
        max_uses: 100
      }
      {:ok, coupon} = CouponClient.create(params)
  """
  @spec create(map()) :: {:ok, Coupon.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/coupon/create", json: params)
    |> Response.parse(struct: Coupon)
  end

  @doc """
  Lists all coupons.

  ## Returns

    * `{:ok, [%Coupon{}]}` - List of coupons
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, coupons} = CouponClient.list()
      active_coupons = Enum.filter(coupons, & &1.active)
  """
  @spec list() :: {:ok, [Coupon.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/coupon/list")
    |> Response.parse(struct: Coupon)
  end
end
