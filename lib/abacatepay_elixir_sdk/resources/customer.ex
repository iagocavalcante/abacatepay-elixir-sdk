defmodule AbacatepayElixirSdk.Customer do
  @moduledoc """
  Customer resource struct.

  Represents a customer in the AbacatePay system.

  ## Fields

    * `:id` - Unique customer identifier
    * `:metadata` - Metadata associated with the customer
    * `:email` - Customer email address
    * `:cellphone` - Customer cellphone number
    * `:tax_id` - Customer tax ID (CPF/CNPJ)
    * `:name` - Customer name
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          metadata: map() | nil,
          email: String.t() | nil,
          cellphone: String.t() | nil,
          tax_id: String.t() | nil,
          name: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [:id, :metadata, :email, :cellphone, :tax_id, :name]
end
