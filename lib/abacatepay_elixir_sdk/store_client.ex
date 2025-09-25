defmodule AbacatepayElixirSdk.StoreClient do
  @moduledoc """
  Client for Store operations.
  """
  alias AbacatepayElixirSdk.HttpClient

  @doc """
  Get store details.
  """
  def get do
    case HttpClient.request(:get, "/store/get") do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end