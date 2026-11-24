defmodule AbacatepayElixirSdk.Mrr do
  @moduledoc """
  Monthly Recurring Revenue (MRR) resource struct.

  Represents MRR metrics from the AbacatePay system.

  ## Fields

    * `:mrr` - In current v1 responses, a map containing `"currency"` and a `"value"` in centavos
    * `:active_subscriptions` - Optional legacy count. V2 exposes the count as `data["totalActiveSubscriptions"]["value"]`.
  """

  @type t :: %__MODULE__{
          mrr: map() | integer() | nil,
          active_subscriptions: integer() | nil
        }

  @derive Jason.Encoder
  defstruct [:mrr, :active_subscriptions]
end
