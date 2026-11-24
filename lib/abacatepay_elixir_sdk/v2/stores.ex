defmodule AbacatepayElixirSdk.V2.Stores do
  @moduledoc """
  Read store details and balances.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/store/get)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Get the store associated with the API key.

  [GET /v2/stores/get](https://docs.abacatepay.com/pages/store/get)
  """
  @spec get() :: V2.result()
  def get() do
    V2.request(:get, "/stores/get")
  end

  @doc """
  List stores visible to the API key.

  [GET /v2/stores/list](https://github.com/AbacatePay/documentation/blob/3ca540002121c2c3fc502b9cfbb48697ffea9849/openapi.yaml#L4622)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/stores/list", params: query)
  end
end
