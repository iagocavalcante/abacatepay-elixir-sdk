defmodule AbacatepayElixirSdk.PixClient do
  @moduledoc """
  Client for PIX QR Code operations.

  Provides functions to create, check, and simulate PIX payments.

  ## Examples

      # Create a PIX QR code
      params = %{amount: 1999, description: "Order #123"}
      {:ok, %Pix{} = pix} = PixClient.create_qrcode(params)

      # Check payment status
      {:ok, %Pix{status: status}} = PixClient.check_status(pix.id)

      # Simulate payment (sandbox only)
      {:ok, %Pix{status: "PAID"}} = PixClient.simulate_payment(pix.id)
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Pix

  @doc """
  Creates a new PIX QR Code.

  ## Parameters

    * `params` - Map with the following keys:
      * `:amount` (required) - Payment amount in cents
      * `:description` (optional) - Payment description
      * `:expires_in` (optional) - Expiration time in seconds

  ## Returns

    * `{:ok, %Pix{}}` - The created PIX QR code
    * `{:error, %Error{}}` - Error details

  ## Examples

      params = %{amount: 1999, description: "Premium subscription"}
      {:ok, pix} = PixClient.create_qrcode(params)
      IO.puts(pix.br_code)
  """
  @spec create_qrcode(map()) :: {:ok, Pix.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create_qrcode(params) do
    HttpClient.request(:post, "/pixQrCode/create", json: params)
    |> Response.parse(struct: Pix)
  end

  @doc """
  Simulates a payment for a PIX QR Code.

  **Note:** This function only works in sandbox/development mode.

  ## Parameters

    * `id` - PIX QR code ID
    * `metadata` - Optional metadata map

  ## Returns

    * `{:ok, %Pix{}}` - The updated PIX with status "PAID"
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, pix} = PixClient.simulate_payment("pix_abc123")
      pix.status # => "PAID"
  """
  @spec simulate_payment(String.t(), map()) ::
          {:ok, Pix.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def simulate_payment(id, metadata \\ %{}) do
    HttpClient.request(:post, "/pixQrCode/simulate-payment",
      params: [id: id],
      json: %{metadata: metadata}
    )
    |> Response.parse(struct: Pix)
  end

  @doc """
  Checks the status of a PIX QR Code payment.

  ## Parameters

    * `id` - PIX QR code ID

  ## Returns

    * `{:ok, %Pix{}}` - The current PIX state
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, pix} = PixClient.check_status("pix_abc123")
      case pix.status do
        "PAID" -> handle_paid()
        "PENDING" -> handle_pending()
        "EXPIRED" -> handle_expired()
      end
  """
  @spec check_status(String.t()) :: {:ok, Pix.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def check_status(id) do
    HttpClient.request(:get, "/pixQrCode/check", params: [id: id])
    |> Response.parse(struct: Pix)
  end
end
