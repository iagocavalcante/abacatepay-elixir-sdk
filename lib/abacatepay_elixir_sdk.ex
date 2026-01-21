defmodule AbacatepayElixirSdk do
  @moduledoc """
  Official Elixir SDK for AbacatePay - Brazil's modern payment platform.

  This SDK provides a complete integration with AbacatePay's API, enabling you to:
  - Process PIX payments with QR codes
  - Create and manage billing/invoices
  - Handle customer data
  - Manage discount coupons
  - Process withdrawals (production only)
  - Access store information and balance
  - Retrieve MRR metrics and revenue data (Trust MRR Integration)

  ## Quick Start

      # Configure your API token
      config :abacatepay_elixir_sdk,
        api_token: "abc_dev_your_token_here",
        environment: :sandbox

      # Create a PIX payment
      alias AbacatepayElixirSdk.PixClient
      alias AbacatepayElixirSdk.Pix

      params = %{
        amount: 1999,  # R$ 19.99 in cents
        description: "Premium Subscription"
      }

      case PixClient.create_qrcode(params) do
        {:ok, %Pix{} = pix} ->
          IO.puts("PIX Code: \#{pix.br_code}")
        {:error, %AbacatepayElixirSdk.Error{} = error} ->
          IO.puts("Error: \#{error.message}")
      end

  ## Configuration

  The SDK requires an API token and environment configuration:

  ### Environment Variables (Recommended)
      export ABACATEPAY_API_TOKEN="abc_dev_your_token_here"
      export ABACATEPAY_ENVIRONMENT="sandbox"

  ### Application Configuration
      config :abacatepay_elixir_sdk,
        api_token: System.get_env("ABACATEPAY_API_TOKEN"),
        environment: :sandbox  # :sandbox or :production

  ## API Clients

  The SDK is organized into specialized client modules:

  - `AbacatepayElixirSdk.BillingClient` - Billing and invoice operations
  - `AbacatepayElixirSdk.CustomerClient` - Customer management
  - `AbacatepayElixirSdk.PixClient` - PIX payment operations
  - `AbacatepayElixirSdk.CouponClient` - Coupon and discount management
  - `AbacatepayElixirSdk.WithdrawClient` - Withdrawal operations (production only)
  - `AbacatepayElixirSdk.StoreClient` - Store information and balance
  - `AbacatepayElixirSdk.PublicMrrClient` - MRR metrics and revenue data

  ## Error Handling

  All client functions return either `{:ok, struct}` or `{:error, %Error{}}` tuples:

      alias AbacatepayElixirSdk.BillingClient
      alias AbacatepayElixirSdk.Billing
      alias AbacatepayElixirSdk.Error

      case BillingClient.create(params) do
        {:ok, %Billing{} = billing} ->
          IO.puts("Created billing: \#{billing.id}")
        {:error, %Error{status: 401}} ->
          IO.puts("Unauthorized - check your API token")
        {:error, %Error{} = error} ->
          IO.puts("Error: \#{error.message}")
      end

  ## Testing

  The SDK includes VCR cassettes for reliable testing without API calls:

      use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

      test "creates billing" do
        use_cassette "billing_create_success" do
          # Your test code here
        end
      end

  For more information, see the [official documentation](https://docs.abacatepay.com).
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
