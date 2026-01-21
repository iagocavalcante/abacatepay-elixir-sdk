defmodule AbacatepayElixirSdk.Withdraw do
  @moduledoc """
  Withdraw resource struct.

  Represents a withdrawal in the AbacatePay system.

  Note: Withdrawals are only available in production environment.

  ## Fields

    * `:id` - Unique withdrawal identifier
    * `:external_id` - External identifier for the withdrawal
    * `:amount` - Withdrawal amount in cents
    * `:status` - Withdrawal status (e.g., "PENDING", "COMPLETED", "FAILED")
    * `:pix_key` - PIX key for the withdrawal destination
    * `:pix_key_type` - Type of PIX key (e.g., "CPF", "EMAIL", "PHONE", "RANDOM")
    * `:created_at` - Creation timestamp
    * `:completed_at` - Completion timestamp
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          external_id: String.t() | nil,
          amount: integer() | nil,
          status: String.t() | nil,
          pix_key: String.t() | nil,
          pix_key_type: String.t() | nil,
          created_at: String.t() | nil,
          completed_at: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :id,
    :external_id,
    :amount,
    :status,
    :pix_key,
    :pix_key_type,
    :created_at,
    :completed_at
  ]
end
