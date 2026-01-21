defmodule AbacatepayElixirSdk.Store do
  @moduledoc """
  Store resource struct.

  Represents store information in the AbacatePay system.

  ## Fields

    * `:id` - Unique store identifier
    * `:name` - Store name
    * `:balance` - Current balance in cents
    * `:pending_balance` - Pending balance in cents
    * `:available_balance` - Available balance for withdrawal in cents
    * `:created_at` - Creation timestamp
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          balance: integer() | nil,
          pending_balance: integer() | nil,
          available_balance: integer() | nil,
          created_at: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [:id, :name, :balance, :pending_balance, :available_balance, :created_at]
end
