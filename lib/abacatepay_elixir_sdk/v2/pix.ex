defmodule AbacatepayElixirSdk.V2.Pix do
  @moduledoc """
  Send PIX transfers from the store balance to third parties.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/dinheiro/enviar-pix)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Send funds to a PIX destination.

  [POST /v2/pix/send](https://docs.abacatepay.com/pages/pix/create)
  """
  @spec send(map()) :: V2.result()
  def send(params) do
    V2.request(:post, "/pix/send", json: params)
  end

  @doc """
  Look up an outbound PIX transfer.

  [GET /v2/pix/get](https://docs.abacatepay.com/pages/pix/get)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/pix/get", params: query)
  end

  @doc """
  Query outbound PIX transfers. The published OpenAPI specification requires the id query parameter.

  [GET /v2/pix/list](https://docs.abacatepay.com/pages/pix/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query) do
    V2.request(:get, "/pix/list", params: query)
  end
end
