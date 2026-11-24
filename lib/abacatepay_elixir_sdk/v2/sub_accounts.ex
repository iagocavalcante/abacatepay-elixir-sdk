defmodule AbacatepayElixirSdk.V2.SubAccounts do
  @moduledoc """
  Manage sellers, their split balances and withdrawals.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/dinheiro/subcontas-e-split)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a seller subaccount.

  [POST /v2/sub-accounts/create](https://docs.abacatepay.com/pages/sub-accounts/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/sub-accounts/create", json: params)
  end

  @doc """
  Fetch a subaccount and its balance by ID.

  [GET /v2/sub-accounts/get](https://docs.abacatepay.com/pages/sub-accounts/get)
  """
  @spec get(String.t()) :: V2.result()
  def get(id) do
    V2.request(:get, "/sub-accounts/get", params: [id: id])
  end

  @doc """
  List subaccounts with optional filters and pagination.

  [GET /v2/sub-accounts/list](https://docs.abacatepay.com/pages/sub-accounts/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/sub-accounts/list", params: query)
  end

  @doc """
  Withdraw funds to the subaccount holder’s registered tax ID.

  [POST /v2/sub-accounts/withdraw](https://docs.abacatepay.com/pages/sub-accounts/withdraw)
  """
  @spec withdraw(map()) :: V2.result()
  def withdraw(params) do
    V2.request(:post, "/sub-accounts/withdraw", json: params)
  end
end
