defmodule AbacatepayElixirSdk do
  @moduledoc """
  Elixir SDK for AbacatePay.

  Use `AbacatepayElixirSdk.V2` for new integrations. Its resource modules cover
  hosted and transparent checkout, subscriptions, the catalog, payouts, transfers,
  store balances, Public MRR and webhook registration.

  The original client modules (including `AbacatepayElixirSdk.BillingClient` and
  `AbacatepayElixirSdk.PixClient`) use API v1 and the `:api_token` setting.
  """

  @doc """
  Returns the legacy API v1 credential configured in `:api_token`.
  """
  def api_token do
    Application.get_env(:abacatepay_elixir_sdk, :api_token)
  end

  @doc """
  Returns the application's environment label, defaulting to `:sandbox`.
  AbacatePay determines the environment of a request from its key.
  """
  def environment do
    Application.get_env(:abacatepay_elixir_sdk, :environment, :sandbox)
  end
end
