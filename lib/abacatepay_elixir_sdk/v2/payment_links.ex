defmodule AbacatepayElixirSdk.V2.PaymentLinks do
  @moduledoc """
  Create and manage reusable hosted payment links.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/cobrar/link-de-pagamento)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a reusable payment link for the supplied catalog items.

  [POST /v2/payment-links/create](https://docs.abacatepay.com/pages/payment-links/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/payment-links/create", json: params)
  end

  @doc """
  Look up a payment link using the supplied filters.

  [GET /v2/payment-links/get](https://docs.abacatepay.com/pages/payment-links/one)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/payment-links/get", params: query)
  end

  @doc """
  List payment links with optional filters and pagination.

  [GET /v2/payment-links/list](https://docs.abacatepay.com/pages/payment-links/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/payment-links/list", params: query)
  end

  @doc """
  Refund an individual payment made through a link.

  [POST /v2/payment-links/refund](https://docs.abacatepay.com/pages/payment-links/refund)
  """
  @spec refund(map()) :: V2.result()
  def refund(params) do
    V2.request(:post, "/payment-links/refund", json: params)
  end

  @doc """
  Delete an unpaid payment link by ID.

  [POST /v2/payment-links/delete](https://github.com/AbacatePay/documentation/blob/3ca540002121c2c3fc502b9cfbb48697ffea9849/openapi.yaml#L2014)
  """
  @spec delete(String.t()) :: V2.result()
  def delete(id) do
    V2.request(:post, "/payment-links/delete", params: [id: id])
  end
end
