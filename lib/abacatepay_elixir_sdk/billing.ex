defmodule AbacatepayElixirSdk.Billing do
  @moduledoc """
  Billing/Invoice resource struct.

  Represents a billing/invoice in the AbacatePay system.

  ## Fields

    * `:id` - Unique billing identifier
    * `:url` - Payment URL for the billing
    * `:amount` - Total amount in cents
    * `:status` - Billing status (e.g., "PENDING", "PAID", "EXPIRED")
    * `:description` - Billing description
    * `:frequency` - Payment frequency (e.g., "ONE_TIME", "MONTHLY")
    * `:methods` - Available payment methods
    * `:products` - List of products in the billing
    * `:metadata` - Additional metadata
    * `:customer` - Associated customer information
    * `:created_at` - Creation timestamp
    * `:expires_at` - Expiration timestamp
  """

  alias AbacatepayElixirSdk.Billing.Product

  @type t :: %__MODULE__{
          id: String.t() | nil,
          url: String.t() | nil,
          amount: integer() | nil,
          status: String.t() | nil,
          description: String.t() | nil,
          frequency: String.t() | nil,
          methods: [String.t()] | nil,
          products: [Product.t()] | nil,
          metadata: map() | nil,
          customer: map() | nil,
          created_at: String.t() | nil,
          expires_at: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :id,
    :url,
    :amount,
    :status,
    :description,
    :frequency,
    :methods,
    :products,
    :metadata,
    :customer,
    :created_at,
    :expires_at
  ]
end

defmodule AbacatepayElixirSdk.Billing.Product do
  @moduledoc """
  Product struct for Billing.

  Represents a product line item in a billing/invoice.

  ## Fields

    * `:external_id` - External identifier for the product
    * `:name` - Product name
    * `:description` - Product description
    * `:quantity` - Quantity of the product
    * `:price` - Unit price in cents
  """

  @type t :: %__MODULE__{
          external_id: String.t() | nil,
          name: String.t() | nil,
          description: String.t() | nil,
          quantity: integer() | nil,
          price: integer() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :external_id,
    :name,
    :description,
    :quantity,
    :price
  ]
end
