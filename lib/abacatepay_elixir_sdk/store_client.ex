defmodule AbacatepayElixirSdk.StoreClient do
  @moduledoc """
  V1 store details and balance. For v2, see `AbacatepayElixirSdk.V2.Stores`.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Store

  @doc """
  Get the store and its balances in centavos.

      alias AbacatepayElixirSdk.StoreClient

      {:ok, store} = StoreClient.get()
      store.balance["available"]
  """
  @spec get() :: {:ok, Store.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get do
    HttpClient.request(:get, "/store/get")
    |> Response.parse(struct: Store)
  end
end
