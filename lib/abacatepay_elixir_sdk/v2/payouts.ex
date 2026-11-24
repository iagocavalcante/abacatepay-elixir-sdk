defmodule AbacatepayElixirSdk.V2.Payouts do
  @moduledoc """
  Withdraw funds to the store owner’s PIX key.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/dinheiro/saques)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a payout with amount, externalId and a nested pix destination.

  [POST /v2/payouts/create](https://docs.abacatepay.com/pages/payouts/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/payouts/create", json: params)
  end

  @doc """
  Look up a payout by ID or external ID.

  [GET /v2/payouts/get](https://docs.abacatepay.com/pages/payouts/get)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/payouts/get", params: query)
  end

  @doc """
  List payouts with optional filters and pagination.

  [GET /v2/payouts/list](https://docs.abacatepay.com/pages/payouts/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/payouts/list", params: query)
  end
end
