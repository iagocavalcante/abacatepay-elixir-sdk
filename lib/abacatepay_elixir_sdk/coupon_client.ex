defmodule AbacatepayElixirSdk.CouponClient do
  @moduledoc """
  Client for Coupon operations.
  """
  alias AbacatepayElixirSdk.HttpClient

  @doc """
  Create a new coupon.
  """
  def create(params) do
    case HttpClient.request(:post, "/coupon/create", body: Jason.encode!(params)) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  @doc """
  List all coupons.
  """
  def list do
    case HttpClient.request(:get, "/coupon/list") do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end
