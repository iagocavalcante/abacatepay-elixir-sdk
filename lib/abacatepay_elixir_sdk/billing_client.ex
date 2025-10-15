defmodule AbacatepayElixirSdk.BillingClient do
  @moduledoc """
  Client for Billing operations.
  """
  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Billing

  @doc """
  Create a new billing.
  """
  def create(params) do
    case HttpClient.request(:post, "/billing/create", body: Jason.encode!(params)) do
      {:ok, %{status: 200, body: body}} when is_map(body) ->
        # Convert string keys to atom keys for struct
        atomized = for {k, v} <- body, into: %{}, do: {String.to_atom(k), v}
        {:ok, struct(Billing, atomized)}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  @doc """
  List billings.
  """
  def list do
    case HttpClient.request(:get, "/billing/list") do
      {:ok, %{status: 200, body: body}} when is_map(body) ->
        {:ok, Enum.map(body["billings"] || [], &struct(Billing, &1))}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end
