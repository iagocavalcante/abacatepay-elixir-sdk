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

  ## Quick Start

      # Configure your API token
      config :abacatepay_elixir_sdk,
        api_token: "abc_dev_your_token_here",
        environment: :sandbox

      # Create a PIX payment
      alias AbacatepayElixirSdk.PixClient

      params = %{
        amount: 1999,  # R$ 19.99 in cents
        description: "Premium Subscription"
      }

      case PixClient.create_qrcode(params) do
        {:ok, qr_data} ->
          IO.puts("PIX Code: \#{qr_data["qrCode"]}")
        {:error, reason} ->
          IO.puts("Error: \#{reason}")
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

  ## Error Handling

  All client functions return either `{:ok, data}` or `{:error, reason}` tuples:

      case BillingClient.create(params) do
        {:ok, billing} -> 
          # Handle success
        {:error, reason} -> 
          # Handle error
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
