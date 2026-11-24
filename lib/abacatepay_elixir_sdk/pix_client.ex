defmodule AbacatepayElixirSdk.PixClient do
  @moduledoc """
  V1 PIX QR code payments. For v2 PIX charges, see `AbacatepayElixirSdk.V2.Transparents`.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Pix

  @doc """
  Create a v1 PIX charge. Send the amount in centavos and optional `expiresIn` in seconds.

      alias AbacatepayElixirSdk.PixClient

      {:ok, pix} = PixClient.create_qrcode(%{amount: 1999, expiresIn: 3600})
      pix.br_code
  """
  @spec create_qrcode(map()) :: {:ok, Pix.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create_qrcode(params) do
    HttpClient.request(:post, "/pixQrCode/create", json: params)
    |> Response.parse(struct: Pix)
  end

  @doc "Mark a v1 PIX charge as paid in test mode, optionally supplying a metadata map."
  @spec simulate_payment(String.t(), map()) ::
          {:ok, Pix.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def simulate_payment(id, metadata \\ %{}) do
    HttpClient.request(:post, "/pixQrCode/simulate-payment",
      params: [id: id],
      json: %{metadata: metadata}
    )
    |> Response.parse(struct: Pix)
  end

  @doc "Get the status of a v1 PIX charge by its ID."
  @spec check_status(String.t()) :: {:ok, Pix.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def check_status(id) do
    HttpClient.request(:get, "/pixQrCode/check", params: [id: id])
    |> Response.parse(struct: Pix)
  end
end
