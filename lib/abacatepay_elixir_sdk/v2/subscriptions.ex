defmodule AbacatepayElixirSdk.V2.Subscriptions do
  @moduledoc """
  Manage subscription checkouts, recurring subscriptions and metered usage.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/cobrar/assinaturas)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Create a checkout for products with a billing cycle.

  [POST /v2/subscriptions/create](https://docs.abacatepay.com/pages/subscriptions/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/subscriptions/create", json: params)
  end

  @doc """
  Look up a subscription using the supplied filters.

  [GET /v2/subscriptions/get](https://docs.abacatepay.com/pages/subscriptions/get)
  """
  @spec get(V2.query()) :: V2.result()
  def get(query) do
    V2.request(:get, "/subscriptions/get", params: query)
  end

  @doc """
  List subscriptions with optional filters and pagination.

  [GET /v2/subscriptions/list](https://docs.abacatepay.com/pages/subscriptions/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/subscriptions/list", params: query)
  end

  @doc """
  Look up a subscription checkout.

  [GET /v2/subscriptions/checkouts/get](https://docs.abacatepay.com/pages/subscriptions/checkouts-get)
  """
  @spec get_checkout(V2.query()) :: V2.result()
  def get_checkout(query) do
    V2.request(:get, "/subscriptions/checkouts/get", params: query)
  end

  @doc """
  List subscription checkouts, including unpaid ones.

  [GET /v2/subscriptions/checkouts/list](https://docs.abacatepay.com/pages/subscriptions/checkouts-list)
  """
  @spec list_checkouts(V2.query()) :: V2.result()
  def list_checkouts(query \\ []) do
    V2.request(:get, "/subscriptions/checkouts/list", params: query)
  end

  @doc """
  Delete a subscription checkout by its checkout ID.

  [POST /v2/subscriptions/checkouts/delete](https://docs.abacatepay.com/pages/subscriptions/checkouts-delete)
  """
  @spec delete_checkout(String.t()) :: V2.result()
  def delete_checkout(id) do
    V2.request(:post, "/subscriptions/checkouts/delete", params: [id: id])
  end

  @doc """
  Cancel an active subscription immediately by its subscription ID.

  [POST /v2/subscriptions/cancel](https://docs.abacatepay.com/pages/subscriptions/cancel)
  """
  @spec cancel(String.t()) :: V2.result()
  def cancel(id) do
    V2.request(:post, "/subscriptions/cancel", json: %{id: id})
  end

  @doc """
  Schedule a change to the products on an active subscription.

  [POST /v2/subscriptions/change-plan](https://docs.abacatepay.com/pages/subscriptions/change-plan)
  """
  @spec change_plan(map()) :: V2.result()
  def change_plan(params) do
    V2.request(:post, "/subscriptions/change-plan", json: params)
  end

  @doc """
  Record metered product usage on an active subscription.

  [POST /v2/subscriptions/record-usage](https://docs.abacatepay.com/pages/subscriptions/record-usage)
  """
  @spec record_usage(map()) :: V2.result()
  def record_usage(params) do
    V2.request(:post, "/subscriptions/record-usage", json: params)
  end
end
