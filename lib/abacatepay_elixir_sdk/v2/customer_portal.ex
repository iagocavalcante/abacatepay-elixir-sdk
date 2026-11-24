defmodule AbacatepayElixirSdk.V2.CustomerPortal do
  @moduledoc """
  Generate a customer portal URL for a paid checkout.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/vender/portal-do-cliente)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Get a portal link using customerId and checkoutId.

  [POST /v2/customer-portal/create](https://docs.abacatepay.com/pages/customer-portal/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/customer-portal/create", json: params)
  end
end
