defmodule AbacatepayElixirSdk.BillingClient do
  @moduledoc """
  Client for Billing/Invoice operations.

  Provides functions to create and list billings/invoices.

  ## Examples

      # Create a billing
      params = %{
        amount: 9900,
        description: "Order #123",
        frequency: "ONE_TIME",
        methods: ["PIX"],
        products: [
          %{name: "Product A", quantity: 1, price: 9900}
        ]
      }
      {:ok, %Billing{} = billing} = BillingClient.create(params)

      # List all billings
      {:ok, billings} = BillingClient.list()
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Billing

  @doc """
  Creates a new billing/invoice.

  ## Parameters

    * `params` - Map with the following keys:
      * `:amount` (required) - Total amount in cents
      * `:description` (optional) - Billing description
      * `:frequency` (required) - Payment frequency ("ONE_TIME", "MONTHLY", etc.)
      * `:methods` (required) - List of payment methods (e.g., ["PIX"])
      * `:products` (optional) - List of product maps
      * `:customer` (optional) - Customer ID or customer data
      * `:metadata` (optional) - Additional metadata

  ## Returns

    * `{:ok, %Billing{}}` - The created billing
    * `{:error, %Error{}}` - Error details

  ## Examples

      params = %{
        amount: 19900,
        description: "Premium Plan - Monthly",
        frequency: "MONTHLY",
        methods: ["PIX"],
        products: [
          %{name: "Premium Plan", quantity: 1, price: 19900, external_id: "premium_001"}
        ],
        metadata: %{order_id: "order_123"}
      }
      {:ok, billing} = BillingClient.create(params)
      IO.puts("Payment URL: \#{billing.url}")
  """
  @spec create(map()) :: {:ok, Billing.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/billing/create", json: params)
    |> Response.parse(struct: Billing)
  end

  @doc """
  Lists all billings/invoices.

  ## Returns

    * `{:ok, [%Billing{}]}` - List of billings
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, billings} = BillingClient.list()
      pending = Enum.filter(billings, & &1.status == "PENDING")
  """
  @spec list() :: {:ok, [Billing.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/billing/list")
    |> Response.parse(struct: Billing, list_key: "billings")
  end
end
