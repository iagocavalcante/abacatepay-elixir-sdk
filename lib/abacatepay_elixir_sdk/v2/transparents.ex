defmodule AbacatepayElixirSdk.V2.Transparents do
  @moduledoc """
  Collect PIX, boleto and card payments in your own checkout.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/cobrar/checkout-transparente)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a charge with a payment method and its nested data.

  `POST /v2/transparents/create` · [PIX](https://docs.abacatepay.com/pages/transparents/create) · [Boleto](https://docs.abacatepay.com/pages/transparents/boleto) · [Card](https://docs.abacatepay.com/pages/transparents/card)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/transparents/create", json: params)
  end

  @doc """
  Quote an amount in cents with an optional coupon and card fee pass-through.

  [GET /v2/transparents/quote](https://docs.abacatepay.com/pages/transparents/quote)
  """
  @spec quote(V2.query()) :: V2.result()
  def quote(query) do
    V2.request(:get, "/transparents/quote", params: query)
  end

  @doc """
  Fetch a transparent checkout by ID.

  [GET /v2/transparents/get](https://github.com/AbacatePay/documentation/blob/3ca540002121c2c3fc502b9cfbb48697ffea9849/openapi.yaml#L2417)
  """
  @spec get(String.t()) :: V2.result()
  def get(id) do
    V2.request(:get, "/transparents/get", params: [id: id])
  end

  @doc """
  Check the status and expiration of a transparent PIX charge by ID.

  [GET /v2/transparents/check](https://docs.abacatepay.com/pages/transparents/check)
  """
  @spec check(String.t()) :: V2.result()
  def check(id) do
    V2.request(:get, "/transparents/check", params: [id: id])
  end

  @doc """
  List transparent charges with optional filters and pagination.

  [GET /v2/transparents/list](https://docs.abacatepay.com/pages/transparents/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/transparents/list", params: query)
  end

  @doc """
  Mark a test-mode PIX charge as paid.

  [POST /v2/transparents/simulate-payment](https://docs.abacatepay.com/pages/transparents/simulate-payment)
  """
  @spec simulate_payment(String.t()) :: V2.result()
  def simulate_payment(id) do
    V2.request(:post, "/transparents/simulate-payment", params: [id: id])
  end

  @doc """
  Refund a paid PIX or card charge by ID with an optional reason.

  [POST /v2/transparents/refund](https://docs.abacatepay.com/pages/transparents/refund)
  """
  @spec refund(map()) :: V2.result()
  def refund(params) do
    V2.request(:post, "/transparents/refund", json: params)
  end
end
