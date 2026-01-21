defmodule AbacatepayElixirSdk.Revenue do
  @moduledoc """
  Revenue metrics resource struct.

  Represents revenue data for a specific period from the AbacatePay system.

  ## Fields

    * `:total_revenue` - Total revenue amount in cents for the period
    * `:total_transactions` - Total number of transactions in the period
    * `:daily_breakdown` - List of daily transaction data
    * `:start_date` - Start date of the period
    * `:end_date` - End date of the period
  """

  @type t :: %__MODULE__{
          total_revenue: integer() | nil,
          total_transactions: integer() | nil,
          daily_breakdown: [map()] | nil,
          start_date: String.t() | nil,
          end_date: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [:total_revenue, :total_transactions, :daily_breakdown, :start_date, :end_date]
end
