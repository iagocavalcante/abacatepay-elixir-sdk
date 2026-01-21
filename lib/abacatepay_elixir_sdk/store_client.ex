defmodule AbacatepayElixirSdk.StoreClient do
  @moduledoc """
  Client for Store operations.

  Provides functions to retrieve store information and balance.

  ## Examples

      {:ok, %Store{} = store} = StoreClient.get()
      IO.puts("Balance: \#{store.balance}")
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Store

  @doc """
  Gets the current store details and balance.

  ## Returns

    * `{:ok, %Store{}}` - Store information including balance
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, store} = StoreClient.get()
      IO.puts("Store: \#{store.name}")
      IO.puts("Available: R$ \#{store.available_balance / 100}")
  """
  @spec get() :: {:ok, Store.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get do
    HttpClient.request(:get, "/store/get")
    |> Response.parse(struct: Store)
  end
end
