# AbacatePay Elixir SDK

[![Hex.pm](https://img.shields.io/hexpm/v/abacatepay_elixir_sdk)](https://hex.pm/packages/abacatepay_elixir_sdk)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue)](https://hexdocs.pm/abacatepay_elixir_sdk)
[![License](https://img.shields.io/hexpm/l/abacatepay_elixir_sdk)](https://github.com/iagocavalcante/abacatepay-elixir-sdk/blob/main/LICENSE)

The official Elixir SDK for [AbacatePay](https://abacatepay.com/) - Brazil's modern payment platform. Build secure, fast payment integrations with PIX, billing, and MRR metrics.

## Features

- **Complete API Coverage** - All AbacatePay endpoints supported
- **Type-Safe Responses** - All API responses return typed structs
- **Structured Error Handling** - Rich error types with HTTP status codes
- **Production Ready** - Robust error handling and security
- **Comprehensive Testing** - 100% API coverage with VCR cassettes
- **Modern Elixir** - Built with Req, Jason, and OTP best practices
- **Full Documentation** - Complete guides and API reference

## Installation

Add `abacatepay_elixir_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:abacatepay_elixir_sdk, "~> 0.1.0"}
  ]
end
```

Then run:

```bash
mix deps.get
```

## Configuration

### Environment Variables (Recommended)

```bash
export ABACATEPAY_API_TOKEN="abc_dev_your_token_here"
export ABACATEPAY_ENVIRONMENT="sandbox"  # or "production"
```

### Application Configuration

In your `config/config.exs`:

```elixir
config :abacatepay_elixir_sdk,
  api_token: System.get_env("ABACATEPAY_API_TOKEN"),
  environment: :sandbox  # :sandbox or :production
```

For production, use `config/runtime.exs`:

```elixir
import Config

if config_env() == :prod do
  config :abacatepay_elixir_sdk,
    api_token: System.get_env("ABACATEPAY_API_TOKEN") || raise("ABACATEPAY_API_TOKEN not set"),
    environment: :production
end
```

## Quick Start

```elixir
# Create a simple PIX payment
alias AbacatepayElixirSdk.PixClient
alias AbacatepayElixirSdk.Pix
alias AbacatepayElixirSdk.Error

params = %{
  amount: 1999,  # R$ 19.99 in cents
  description: "Premium Subscription"
}

case PixClient.create_qrcode(params) do
  {:ok, %Pix{} = pix} ->
    IO.puts("PIX ID: #{pix.id}")
    IO.puts("BR Code: #{pix.br_code}")
    IO.puts("Status: #{pix.status}")

  {:error, %Error{} = error} ->
    IO.puts("Error: #{error.message}")
    IO.puts("Status: #{error.status}")
end
```

## API Reference

### Store Operations

```elixir
alias AbacatepayElixirSdk.StoreClient
alias AbacatepayElixirSdk.Store

# Get store details and balance
{:ok, %Store{} = store} = StoreClient.get()
IO.puts("Store: #{store.name}")
IO.puts("Balance: #{store.balance}")
```

### Billing Operations

```elixir
alias AbacatepayElixirSdk.BillingClient
alias AbacatepayElixirSdk.Billing

# Create a billing/invoice
params = %{
  amount: 2999,  # R$ 29.99 in cents
  description: "Monthly Subscription",
  frequency: "ONE_TIME",  # or "MONTHLY", "YEARLY"
  methods: ["PIX"]
}

{:ok, %Billing{} = billing} = BillingClient.create(params)
IO.puts("Billing ID: #{billing.id}")
IO.puts("Payment URL: #{billing.url}")

# List all billings
{:ok, billings} = BillingClient.list()
Enum.each(billings, fn %Billing{} = b -> IO.puts(b.id) end)
```

### Customer Management

```elixir
alias AbacatepayElixirSdk.CustomerClient
alias AbacatepayElixirSdk.Customer

# Create a customer
customer_params = %{
  name: "João Silva",
  email: "joao@example.com",
  cellphone: "11999999999",
  taxId: "11144477735"  # Valid CPF
}

{:ok, %Customer{} = customer} = CustomerClient.create(customer_params)
IO.puts("Customer ID: #{customer.id}")

# List all customers
{:ok, customers} = CustomerClient.list()
```

### PIX Operations

```elixir
alias AbacatepayElixirSdk.PixClient
alias AbacatepayElixirSdk.Pix

# Create PIX QR Code
pix_params = %{
  amount: 5000,  # R$ 50.00
  description: "Product Purchase"
}

{:ok, %Pix{} = pix} = PixClient.create_qrcode(pix_params)
IO.puts("PIX BR Code: #{pix.br_code}")

# Check payment status
{:ok, %Pix{status: status}} = PixClient.check_status(pix.id)
IO.puts("Payment status: #{status}")

# Simulate payment (development mode only)
{:ok, %Pix{status: "PAID"}} = PixClient.simulate_payment(pix.id)
```

### Coupon Management

```elixir
alias AbacatepayElixirSdk.CouponClient
alias AbacatepayElixirSdk.Coupon

# Create a discount coupon
coupon_params = %{
  code: "SAVE20",
  type: "percentage",
  value: 20,
  maxUses: 100,
  expiresAt: "2024-12-31T23:59:59Z",
  notes: "20% off for new customers"
}

{:ok, %Coupon{} = coupon} = CouponClient.create(coupon_params)
IO.puts("Coupon code: #{coupon.code}")

# List all coupons
{:ok, coupons} = CouponClient.list()
active = Enum.filter(coupons, & &1.active)
```

### Withdrawal Operations

> **Note**: Withdrawal operations are only available in production mode.

```elixir
alias AbacatepayElixirSdk.WithdrawClient
alias AbacatepayElixirSdk.Withdraw

# Create withdrawal
withdraw_params = %{
  amount: 10000,  # R$ 100.00
  pix_key: "email@example.com",
  pix_key_type: "EMAIL",
  external_id: "withdraw-001"
}

{:ok, %Withdraw{} = withdraw} = WithdrawClient.create(withdraw_params)

# Get withdrawal by external ID
{:ok, %Withdraw{} = withdraw} = WithdrawClient.get("withdraw-001")
IO.puts("Withdrawal status: #{withdraw.status}")

# List all withdrawals
{:ok, withdrawals} = WithdrawClient.list()
```

### Public MRR Metrics

The Trust MRR Integration allows you to share revenue metrics transparently with stakeholders.

```elixir
alias AbacatepayElixirSdk.PublicMrrClient
alias AbacatepayElixirSdk.{Mrr, MerchantInfo, Revenue}

# Get Monthly Recurring Revenue
{:ok, %Mrr{} = mrr} = PublicMrrClient.get_mrr()
IO.puts("MRR: R$ #{mrr.mrr / 100}")
IO.puts("Active subscriptions: #{mrr.active_subscriptions}")

# Get merchant info
{:ok, %MerchantInfo{} = info} = PublicMrrClient.get_merchant_info()
IO.puts("Store: #{info.name}")
IO.puts("Website: #{info.website}")

# Get revenue for a period (cached for 1 hour)
{:ok, %Revenue{} = revenue} = PublicMrrClient.get_revenue("2024-01-01", "2024-01-31")
IO.puts("Total revenue: R$ #{revenue.total_revenue / 100}")
IO.puts("Transactions: #{revenue.total_transactions}")
```

## Error Handling

The SDK provides structured error handling with the `AbacatepayElixirSdk.Error` struct:

```elixir
alias AbacatepayElixirSdk.BillingClient
alias AbacatepayElixirSdk.Billing
alias AbacatepayElixirSdk.Error

case BillingClient.create(params) do
  {:ok, %Billing{} = billing} ->
    # Success - billing is a typed struct
    process_billing(billing)

  {:error, %Error{status: 401}} ->
    # Unauthorized - invalid API token
    {:error, :unauthorized}

  {:error, %Error{status: 400, message: message}} ->
    # Validation error from API
    {:error, {:validation_error, message}}

  {:error, %Error{code: "NETWORK_ERROR", message: message}} ->
    # Network/connection error
    {:error, {:network_error, message}}

  {:error, %Error{} = error} ->
    # Other API errors
    Logger.error("API error: #{error}")
    {:error, error}
end
```

### Error Struct Fields

| Field | Type | Description |
|-------|------|-------------|
| `status` | `integer \| nil` | HTTP status code (400, 401, 404, 500, etc.) |
| `code` | `string \| nil` | API error code (e.g., "INVALID_PARAMS", "NETWORK_ERROR") |
| `message` | `string` | Human-readable error message |
| `details` | `map \| nil` | Additional error details |

## Data Structures

All API responses are returned as typed structs:

| Struct | Description |
|--------|-------------|
| `Billing` | Billing/invoice with URL, amount, status |
| `Billing.Product` | Product line item in a billing |
| `Customer` | Customer with name, email, tax_id |
| `Pix` | PIX QR code with br_code, status, amount |
| `Coupon` | Discount coupon with code, discount, uses |
| `Store` | Store info with balance details |
| `Withdraw` | Withdrawal with pix_key, status |
| `Mrr` | Monthly recurring revenue metrics |
| `MerchantInfo` | Merchant name, website, creation date |
| `Revenue` | Revenue metrics for a period |

## Testing

The SDK includes comprehensive tests with VCR cassettes for reliable testing:

```bash
# Run all tests
mix test

# Run tests with coverage
mix coveralls

# Run specific test file
mix test test/abacatepay_elixir_sdk/billing_client_test.exs
```

### Testing Your Integration

```elixir
# In your test files
use ExUnit.Case
use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

alias AbacatepayElixirSdk.BillingClient
alias AbacatepayElixirSdk.Billing

test "creates billing successfully" do
  use_cassette "billing_create_success" do
    params = %{amount: 1000, description: "Test", frequency: "ONE_TIME", methods: ["PIX"]}
    assert {:ok, %Billing{} = billing} = BillingClient.create(params)
    assert is_binary(billing.id)
  end
end
```

## Environment Support

### Sandbox (Development)
- All endpoints available except withdrawals
- Use test API tokens starting with `abc_dev_`
- Payment simulation available via `PixClient.simulate_payment/2`
- Safe for development and testing

### Production
- All endpoints available including withdrawals
- Use production API tokens starting with `abc_live_`
- Real payment processing
- MRR metrics available with real data

## Rate Limiting & Best Practices

- **Rate Limits**: 100 requests per minute per API key
- **Retries**: Implement exponential backoff for failed requests
- **Idempotency**: Use unique external IDs for create operations
- **Monitoring**: Log all API responses for debugging

```elixir
# Example with retry logic
defmodule PaymentService do
  alias AbacatepayElixirSdk.BillingClient
  alias AbacatepayElixirSdk.Billing
  alias AbacatepayElixirSdk.Error

  def create_billing_with_retry(params, retries \\ 3) do
    case BillingClient.create(params) do
      {:ok, %Billing{} = billing} ->
        {:ok, billing}

      {:error, %Error{code: "NETWORK_ERROR"}} when retries > 0 ->
        Process.sleep(1000 * (4 - retries))  # Exponential backoff
        create_billing_with_retry(params, retries - 1)

      {:error, error} ->
        {:error, error}
    end
  end
end
```

## Security

- **API Keys**: Never commit API keys to version control
- **Environment Variables**: Use secure environment management
- **HTTPS Only**: All API calls use HTTPS encryption
- **Request Signing**: Built-in request authentication
- **Data Filtering**: Sensitive data excluded from VCR cassettes

## Support & Resources

- **[API Documentation](https://docs.abacatepay.com/)** - Complete API reference
- **[Discord Community](https://discord.gg/abacatepay)** - Developer support
- **[Issue Tracker](https://github.com/iagocavalcante/abacatepay-elixir-sdk/issues)** - Bug reports
- **[Email Support](mailto:dev@abacatepay.com)** - Technical questions

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes and migration guides.

## License

This SDK is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

<div align="center">
  <strong>Built with love for the Elixir community</strong><br>
  <a href="https://abacatepay.com">AbacatePay</a> |
  <a href="https://docs.abacatepay.com">Documentation</a> |
  <a href="https://github.com/iagocavalcante/abacatepay-elixir-sdk">GitHub</a>
</div>
