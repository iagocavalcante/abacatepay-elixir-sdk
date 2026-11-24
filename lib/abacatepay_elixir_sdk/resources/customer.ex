defmodule AbacatepayElixirSdk.Customer do
  @moduledoc """
  Customer resource struct.

  API v1 commonly returns the contact fields inside `metadata`. For that shape,
  read the email from `customer.metadata["email"]`. The top-level fields are
  populated when the response includes them at the top level.

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
