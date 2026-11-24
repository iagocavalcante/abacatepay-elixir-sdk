defmodule AbacatepayElixirSdk.V2.Coupons do
  @moduledoc """
  Manage checkout discount codes.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/vender/cupons)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a coupon using code, discountKind, discount and maxRedeems.

  [POST /v2/coupons/create](https://docs.abacatepay.com/pages/coupons/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/coupons/create", json: params)
  end

  @doc """
  Look up a coupon by ID (its code), optionally filtering by status.

  [GET /v2/coupons/get](https://docs.abacatepay.com/pages/coupons/get)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/coupons/get", params: query)
  end

  @doc """
  List coupons with optional filters and pagination.

  [GET /v2/coupons/list](https://docs.abacatepay.com/pages/coupons/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/coupons/list", params: query)
  end

  @doc """
  Delete a coupon by ID.

  [POST /v2/coupons/delete](https://docs.abacatepay.com/pages/coupons/delete)
  """
  @spec delete(String.t()) :: V2.result()
  def delete(id) do
    V2.request(:post, "/coupons/delete", params: [id: id])
  end

  @doc """
  Switch a coupon between ACTIVE and DISABLED.

  [POST /v2/coupons/toggle](https://docs.abacatepay.com/pages/coupons/toggle)
  """
  @spec toggle(String.t()) :: V2.result()
  def toggle(id) do
    V2.request(:post, "/coupons/toggle", json: %{id: id})
  end
end
