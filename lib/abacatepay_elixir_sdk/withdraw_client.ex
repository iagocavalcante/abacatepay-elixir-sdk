defmodule AbacatepayElixirSdk.WithdrawClient do
  @moduledoc """
  Client for Withdraw operations.
  """
  alias AbacatepayElixirSdk.HttpClient

  @doc """
  Create a new withdraw.
  """
  def create(params) do
    case HttpClient.request(:post, "/withdraw/create", body: Jason.encode!(params)) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  @doc """
  Get a specific withdraw by external ID.
  """
  def get(external_id) do
    path = "/withdraw/get?externalId=#{external_id}"
    case HttpClient.request(:get, path) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  @doc """
  List all withdraws.
  """
  def list do
    case HttpClient.request(:get, "/withdraw/list") do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end