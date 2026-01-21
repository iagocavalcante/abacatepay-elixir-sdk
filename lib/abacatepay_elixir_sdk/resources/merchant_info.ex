defmodule AbacatepayElixirSdk.MerchantInfo do
  @moduledoc """
  Merchant information resource struct.

  Represents basic store/merchant information from the AbacatePay system.

  ## Fields

    * `:name` - Store/merchant name
    * `:website` - Store website URL
    * `:created_at` - Account creation timestamp
  """

  @type t :: %__MODULE__{
          name: String.t() | nil,
          website: String.t() | nil,
          created_at: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [:name, :website, :created_at]
end
