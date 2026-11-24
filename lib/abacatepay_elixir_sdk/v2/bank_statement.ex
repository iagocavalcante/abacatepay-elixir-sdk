defmodule AbacatepayElixirSdk.V2.BankStatement do
  @moduledoc """
  Read transactions that affect the store balance.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/dinheiro/saldo-e-extrato)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  List statement entries with optional filters and pagination.

  [GET /v2/bank-statement/list](https://docs.abacatepay.com/pages/bank-statement/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/bank-statement/list", params: query)
  end
end
