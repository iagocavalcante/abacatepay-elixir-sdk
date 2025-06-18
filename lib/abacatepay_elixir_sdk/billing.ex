defmodule AbacatepayElixirSdk.Billing do
  @moduledoc """
  Billing resource struct (WIP).
  """
  @derive Jason.Encoder
  defstruct [
    :frequency,
    :methods,
    :products,
    :metadata,
    :customer
  ]
end

defmodule AbacatepayElixirSdk.Billing.Product do
  @moduledoc """
  Product struct for Billing (WIP).
  """
  @derive Jason.Encoder
  defstruct [
    :external_id,
    :name,
    :description,
    :quantity,
    :price
  ]
end
