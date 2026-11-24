defmodule AbacatepayElixirSdk.V2.Customers do
  @moduledoc """
  Create and look up customers for your store.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/vender/clientes)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create or update a customer. The email field is required.

  [POST /v2/customers/create](https://docs.abacatepay.com/pages/client/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/customers/create", json: params)
  end

  @doc """
  Look up a customer by ID, email or tax ID.

  [GET /v2/customers/get](https://docs.abacatepay.com/pages/client/get)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/customers/get", params: query)
  end

  @doc """
  List customers with optional filters and pagination.

  [GET /v2/customers/list](https://docs.abacatepay.com/pages/client/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/customers/list", params: query)
  end

  @doc """
  Delete a customer by ID.

  [POST /v2/customers/delete](https://docs.abacatepay.com/pages/client/delete)
  """
  @spec delete(String.t()) :: V2.result()
  def delete(id) do
    V2.request(:post, "/customers/delete", params: [id: id])
  end
end
