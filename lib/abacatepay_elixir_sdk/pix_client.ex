defmodule AbacatepayElixirSdk.PixClient do
  @moduledoc """
  Client for Pix QRCode operations.
  """
  alias AbacatepayElixirSdk.HttpClient

  @doc """
  Create a new Pix QRCode.
  """
  def create_qrcode(params) do
    case HttpClient.request(:post, "/pixQrCode/create", body: Jason.encode!(params)) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  @doc """
  Simulate a payment for a Pix QRCode (dev mode only).
  """
  def simulate_payment(id, metadata \\ %{}) do
    path = "/pixQrCode/simulate-payment?id=#{id}"
    case HttpClient.request(:post, path, body: Jason.encode!(%{"metadata" => metadata})) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end

  @doc """
  Check the status of a Pix QRCode payment.
  """
  def check_status(id) do
    path = "/pixQrCode/check?id=#{id}"
    case HttpClient.request(:get, path) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end
