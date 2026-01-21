defmodule AbacatepayElixirSdk.Pix do
  @moduledoc """
  PIX QR Code resource struct.

  Represents a PIX QR code payment in the AbacatePay system.

  ## Fields

    * `:id` - Unique PIX QR code identifier
    * `:amount` - Payment amount in cents
    * `:status` - Payment status (e.g., "PENDING", "PAID", "EXPIRED")
    * `:dev_mode` - Whether this is a development/sandbox payment
    * `:br_code` - PIX BR Code (copy and paste code)
    * `:br_code_base64` - PIX QR code image in base64 format
    * `:platform_fee` - Platform fee amount
    * `:created_at` - Creation timestamp
    * `:updated_at` - Last update timestamp
    * `:expires_at` - Expiration timestamp
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          amount: integer() | nil,
          status: String.t() | nil,
          dev_mode: boolean() | nil,
          br_code: String.t() | nil,
          br_code_base64: String.t() | nil,
          platform_fee: integer() | nil,
          created_at: String.t() | nil,
          updated_at: String.t() | nil,
          expires_at: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :id,
    :amount,
    :status,
    :dev_mode,
    :br_code,
    :br_code_base64,
    :platform_fee,
    :created_at,
    :updated_at,
    :expires_at
  ]
end
