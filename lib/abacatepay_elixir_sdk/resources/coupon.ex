defmodule AbacatepayElixirSdk.Coupon do
  @moduledoc """
  Coupon resource struct.

  The v1 client copies matching API fields into this legacy struct. The coupon
  code is returned as `id` in the documented v1 response. For the full coupon
  data, including `"status"` and `"maxRedeems"`, see `AbacatepayElixirSdk.V2.Coupons`.

  ## Fields

    * `:id` - Unique coupon identifier
    * `:code` - Coupon code
    * `:discount` - Discount amount or percentage
    * `:discount_type` - Type of discount (e.g., "PERCENTAGE", "FIXED")
    * `:max_uses` - Maximum number of times the coupon can be used
    * `:uses` - Current number of uses
    * `:active` - Whether the coupon is active
    * `:expires_at` - Expiration timestamp
    * `:created_at` - Creation timestamp
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          code: String.t() | nil,
          discount: integer() | nil,
          discount_type: String.t() | nil,
          max_uses: integer() | nil,
          uses: integer() | nil,
          active: boolean() | nil,
          expires_at: String.t() | nil,
          created_at: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :id,
    :code,
    :discount,
    :discount_type,
    :max_uses,
    :uses,
    :active,
    :expires_at,
    :created_at
  ]
end
