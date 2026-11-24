defmodule AbacatepayElixirSdk.V2.Products do
  @moduledoc """
  Manage the product catalog used by hosted checkouts and subscriptions.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/vender/produtos)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a product with an external ID, name, price in cents and currency.

  [POST /v2/products/create](https://docs.abacatepay.com/pages/products/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/products/create", json: params)
  end

  @doc """
  Look up a product by ID, external ID or name.

  [GET /v2/products/get](https://docs.abacatepay.com/pages/products/get)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/products/get", params: query)
  end

  @doc """
  List products with optional filters and pagination.

  [GET /v2/products/list](https://docs.abacatepay.com/pages/products/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/products/list", params: query)
  end

  @doc """
  Archive a product by ID.

  [POST /v2/products/delete](https://docs.abacatepay.com/pages/products/delete)
  """
  @spec delete(String.t()) :: V2.result()
  def delete(id) do
    V2.request(:post, "/products/delete", params: [id: id])
  end
end
