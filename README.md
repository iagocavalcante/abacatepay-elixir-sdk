# AbacatePay Elixir SDK

[![Hex.pm](https://img.shields.io/hexpm/v/abacatepay_elixir_sdk)](https://hex.pm/packages/abacatepay_elixir_sdk)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue)](https://hexdocs.pm/abacatepay_elixir_sdk)
[![License](https://img.shields.io/hexpm/l/abacatepay_elixir_sdk)](https://github.com/iagocavalcante/abacatepay-elixir-sdk/blob/main/LICENSE)

The official Elixir SDK for [AbacatePay](https://abacatepay.com/) - Brazil's modern payment platform. Build secure, fast payment integrations with PIX, cards, and billing management.

## Features

- 🏦 **Complete API Coverage** - All AbacatePay endpoints supported
- 🔒 **Production Ready** - Robust error handling and security
- 📊 **Comprehensive Testing** - 100% API coverage with VCR cassettes
- 🚀 **Modern Elixir** - Built with Req, Jason, and OTP best practices
- 📖 **Full Documentation** - Complete guides and API reference
- 🐛 **Developer Friendly** - Detailed error messages and debugging support

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

params = %{
  amount: 1999,  # R$ 19.99 in cents
  description: "Premium Subscription"
}

case PixClient.create_qrcode(params) do
  {:ok, qr_data} ->
    # qr_data contains: id, qrCode, paymentLink
    IO.puts("PIX Code: #{qr_data["qrCode"]}")
    IO.puts("Payment Link: #{qr_data["paymentLink"]}")

  {:error, reason} ->
    IO.puts("Error: #{reason}")
end
```

## API Reference

### Store Operations

```elixir
alias AbacatepayElixirSdk.StoreClient

# Get store details and balance
{:ok, store} = StoreClient.get()
# Returns: %{"id" => "...", "name" => "...", "balance" => %{...}}
```

### Billing Operations

```elixir
alias AbacatepayElixirSdk.BillingClient

# Create a billing/invoice
params = %{
  amount: 2999,  # R$ 29.99 in cents
  description: "Monthly Subscription",
  frequency: "oneTime"  # or "monthly", "yearly"
}

{:ok, billing} = BillingClient.create(params)

# List all billings
{:ok, billings} = BillingClient.list()
```

### Customer Management

```elixir
alias AbacatepayElixirSdk.CustomerClient

# Create a customer
customer_params = %{
  name: "João Silva",
  email: "joao@example.com",
  cellphone: "11999999999",
  taxId: "11144477735"  # Valid CPF
}

{:ok, customer} = CustomerClient.create(customer_params)

# List all customers
{:ok, customers} = CustomerClient.list()
```

### PIX Operations

```elixir
alias AbacatepayElixirSdk.PixClient

# Create PIX QR Code
pix_params = %{
  amount: 5000,  # R$ 50.00
  description: "Product Purchase"
}

{:ok, qr_data} = PixClient.create_qrcode(pix_params)

# Check payment status
{:ok, status} = PixClient.check_status(qr_data["id"])

# Simulate payment (development mode only)
{:ok, payment} = PixClient.simulate_payment(qr_data["id"], %{test: "data"})
```

### Coupon Management

```elixir
alias AbacatepayElixirSdk.CouponClient

# Create a discount coupon
coupon_params = %{
  code: "SAVE20",
  type: "percentage",
  value: 20,
  maxUses: 100,
  expiresAt: "2024-12-31T23:59:59Z",
  notes: "20% off for new customers"
}

{:ok, coupon} = CouponClient.create(coupon_params)

# List all coupons
{:ok, coupons} = CouponClient.list()
```

### Withdrawal Operations

> **Note**: Withdrawal operations are only available in production mode.

```elixir
alias AbacatepayElixirSdk.WithdrawClient

# Create withdrawal
withdraw_params = %{
  amount: 10000,  # R$ 100.00
  externalId: "withdraw-001",
  bankAccount: %{
    bank: "001",
    agency: "1234",
    account: "12345678",
    accountType: "checking"
  }
}

{:ok, withdraw} = WithdrawClient.create(withdraw_params)

# Get withdrawal by external ID
{:ok, withdraw} = WithdrawClient.get("withdraw-001")

# List all withdrawals
{:ok, withdrawals} = WithdrawClient.list()
```

## Error Handling

The SDK provides structured error handling:

```elixir
case BillingClient.create(invalid_params) do
  {:ok, billing} ->
    # Success case
    process_billing(billing)

  {:error, "body must have required property 'frequency'"} ->
    # Validation error from API
    {:error, :invalid_frequency}

  {:error, %{reason: :timeout}} ->
    # Network timeout
    {:error, :network_timeout}

  {:error, reason} ->
    # Other errors
    {:error, reason}
end
```

## Testing

The SDK includes comprehensive tests with VCR cassettes for reliable testing:

```bash
# Run all tests
mix test

# Run tests with coverage
mix test --cover

# Run specific test file
mix test test/abacatepay_elixir_sdk/billing_client_test.exs
```

### Testing Your Integration

```elixir
# In your test files
use ExUnit.Case
use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

test "creates billing successfully" do
  use_cassette "billing_create_success" do
    params = %{amount: 1000, description: "Test", frequency: "oneTime"}
    assert {:ok, billing} = BillingClient.create(params)
  end
end
```

## Environment Support

### Sandbox (Development)
- All endpoints available except withdrawals
- Use test API tokens starting with `abc_dev_`
- Payment simulation available
- Safe for development and testing

### Production
- All endpoints available including withdrawals
- Use production API tokens starting with `abc_live_`
- Real payment processing
- Requires PCI compliance for card operations

## Rate Limiting & Best Practices

- **Rate Limits**: 100 requests per minute per API key
- **Retries**: Implement exponential backoff for failed requests
- **Idempotency**: Use unique external IDs for create operations
- **Monitoring**: Log all API responses for debugging

```elixir
# Example with retry logic
defmodule PaymentService do
  def create_billing_with_retry(params, retries \\ 3) do
    case BillingClient.create(params) do
      {:ok, billing} -> {:ok, billing}
      {:error, reason} when retries > 0 ->
        Process.sleep(1000)
        create_billing_with_retry(params, retries - 1)
      error -> error
    end
  end
end
```

## Security

- ✅ **API Keys**: Never commit API keys to version control
- ✅ **Environment Variables**: Use secure environment management
- ✅ **HTTPS Only**: All API calls use HTTPS encryption
- ✅ **Request Signing**: Built-in request authentication
- ✅ **Data Filtering**: Sensitive data excluded from logs

## Support & Resources

- 📖 **[API Documentation](https://docs.abacatepay.com/)** - Complete API reference
- 💬 **[Discord Community](https://discord.gg/abacatepay)** - Developer support
- 🐛 **[Issue Tracker](https://github.com/iagocavalcante/abacatepay-elixir-sdk/issues)** - Bug reports
- 📧 **[Email Support](mailto:dev@abacatepay.com)** - Technical questions

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
  <strong>Built with ❤️ for the Elixir community</strong><br>
  <a href="https://abacatepay.com">AbacatePay</a> •
  <a href="https://docs.abacatepay.com">Documentation</a> •
  <a href="https://github.com/iagocavalcante/abacatepay-elixir-sdk">GitHub</a>
</div>
