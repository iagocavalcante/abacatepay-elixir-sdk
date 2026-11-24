defmodule AbacatepayElixirSdk.V2.Checkouts do
  @moduledoc """
  Collect a one-time payment through an AbacatePay-hosted checkout.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/cobrar/checkout)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a checkout with a list of catalog items and their quantities.

  [POST /v2/checkouts/create](https://docs.abacatepay.com/pages/payment/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/checkouts/create", json: params)
  end

  @doc """
  Look up a checkout by ID, external ID or customer ID.

  [GET /v2/checkouts/get](https://docs.abacatepay.com/pages/payment/one)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/checkouts/get", params: query)
  end

  @doc """
  List one-time checkouts with optional filters and pagination.

  [GET /v2/checkouts/list](https://docs.abacatepay.com/pages/payment/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/checkouts/list", params: query)
  end

  @doc """
  Refund a paid checkout or charge by ID with an optional reason.

  [POST /v2/checkouts/refund](https://docs.abacatepay.com/pages/payment/refund)
  """
  @spec refund(map()) :: V2.result()
  def refund(params) do
    V2.request(:post, "/checkouts/refund", json: params)
  end

  @doc """
  Delete an unpaid checkout by ID.

  [POST /v2/checkouts/delete](https://github.com/AbacatePay/documentation/blob/3ca540002121c2c3fc502b9cfbb48697ffea9849/openapi.yaml#L1414)
  """
  @spec delete(String.t()) :: V2.result()
  def delete(id) do
    V2.request(:post, "/checkouts/delete", params: [id: id])
  end
end
