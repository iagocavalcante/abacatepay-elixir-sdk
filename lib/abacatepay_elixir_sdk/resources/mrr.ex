defmodule AbacatepayElixirSdk.Mrr do
  @moduledoc """
  Monthly Recurring Revenue (MRR) resource struct.

  Represents MRR metrics from the AbacatePay system.

  ## Fields

    * `:mrr` - Monthly recurring revenue value in cents
    * `:active_subscriptions` - Total count of active subscriptions
  """

  @type t :: %__MODULE__{
          mrr: integer() | nil,
          active_subscriptions: integer() | nil
        }

  @derive Jason.Encoder
  defstruct [:mrr, :active_subscriptions]
end
