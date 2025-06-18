defmodule AbacatepayElixirSdk do
  @moduledoc """
  AbacatePay Elixir SDK
  """

  @doc """
  Returns the configured API token.
  """
  def api_token do
    Application.get_env(:abacatepay_elixir_sdk, :api_token)
  end

  @doc """
  Returns the configured environment (:sandbox or :production).
  """
  def environment do
    Application.get_env(:abacatepay_elixir_sdk, :environment, :sandbox)
  end
end
