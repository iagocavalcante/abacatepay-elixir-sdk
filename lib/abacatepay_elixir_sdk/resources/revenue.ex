defmodule AbacatepayElixirSdk.Revenue do
  @moduledoc """
  Revenue metrics resource struct.

  The v1 client exposes `total_revenue` and `total_transactions`. For the API's
  daily breakdown under `"transactionsPerDay"`, use `AbacatepayElixirSdk.V2.PublicMrr.revenue/2`.

  ## Fields

    * `:total_revenue` - Total revenue amount in cents for the period
    * `:total_transactions` - Total number of transactions in the period
    * `:daily_breakdown`, `:start_date`, `:end_date` - Optional legacy fields
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
