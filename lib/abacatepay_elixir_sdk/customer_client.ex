defmodule AbacatepayElixirSdk.CustomerClient do
  @moduledoc """
  Client for Customer operations.
  """
  alias AbacatepayElixirSdk.HttpClient

  @doc """
  Create a new customer.
  """
  def create(params) do
    case HttpClient.request(:post, "/customer/create", body: Jason.encode!(params)) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  # Functions for listing and creating customers will go here
end
