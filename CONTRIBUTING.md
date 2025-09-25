# Contributing to AbacatePay Elixir SDK

Thank you for your interest in contributing to the AbacatePay Elixir SDK! This guide will help you get started.

## Development Setup

### Prerequisites
- Elixir 1.18+ and Erlang/OTP 26+
- Git
- AbacatePay development API token

### Getting Started

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/iagocavalcante/abacatepay-elixir-sdk.git
   cd abacatepay-elixir-sdk
   ```

2. **Install dependencies**
   ```bash
   mix deps.get
   ```

3. **Set up environment variables**
   ```bash
   export ABACATEPAY_API_TOKEN="abc_dev_your_token_here"
   export ABACATEPAY_ENVIRONMENT="sandbox"
   ```

4. **Run tests to ensure everything works**
   ```bash
   mix test
   ```

## Code Style and Standards

### Elixir Style Guide
- Follow the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)
- Use `mix format` to format your code
- Maximum line length: 100 characters
- Use descriptive variable and function names

### Documentation
- All public functions must have `@doc` annotations
- Include examples in documentation when helpful
- Use `@spec` for function specifications
- Module documentation should explain the module's purpose

### Example:
```elixir
@doc """
Creates a new billing/invoice.

## Parameters
- `params` - Map with billing parameters:
  - `:amount` - Amount in cents (integer)
  - `:description` - Billing description (string)
  - `:frequency` - Billing frequency: "oneTime", "monthly", "yearly" (string)

## Returns
- `{:ok, billing}` - Success with billing data
- `{:error, reason}` - Error with reason

## Examples
    iex> params = %{amount: 1000, description: "Test", frequency: "oneTime"}
    iex> BillingClient.create(params)
    {:ok, %{"id" => "bill_123", "amount" => 1000, ...}}
"""
@spec create(map()) :: {:ok, map()} | {:error, String.t()}
def create(params) do
  # Implementation
end
```

## Testing Guidelines

### Test Structure
- Write tests for all public functions
- Use descriptive test names that explain the scenario
- Group related tests with `describe/2` blocks
- Use VCR cassettes for API integration tests

### VCR Testing
- Record new cassettes when adding API endpoints
- Update cassettes when API responses change
- Filter sensitive data (API keys, personal info) from cassettes
- Use meaningful cassette names that describe the scenario

### Example Test:
```elixir
defmodule AbacatepayElixirSdk.BillingClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  describe "create/1" do
    test "creates billing with valid parameters" do
      use_cassette "billing_create_success" do
        params = %{
          amount: 1000,
          description: "Test billing",
          frequency: "oneTime"
        }

        assert {:ok, billing} = BillingClient.create(params)
        assert is_binary(billing["id"])
        assert billing["amount"] == 1000
      end
    end

    test "returns error with invalid parameters" do
      use_cassette "billing_create_error" do
        params = %{invalid: "data"}
        assert {:error, _reason} = BillingClient.create(params)
      end
    end
  end
end
```

## Pull Request Process

### Before Submitting
1. **Run the full test suite**
   ```bash
   mix test
   ```

2. **Format your code**
   ```bash
   mix format
   ```

3. **Check for warnings**
   ```bash
   mix compile --warnings-as-errors
   ```

4. **Update documentation if needed**
   ```bash
   mix docs
   ```

### PR Requirements
- [ ] All tests pass
- [ ] Code follows style guidelines
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated (if applicable)
- [ ] VCR cassettes are updated (if API changes)

### PR Description Template
```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Added tests for new functionality
- [ ] Updated existing tests
- [ ] All tests pass

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (if needed)
```

## API Client Guidelines

### Error Handling
- Always return `{:ok, data}` or `{:error, reason}` tuples
- Handle all HTTP status codes appropriately
- Provide meaningful error messages
- Log errors for debugging when appropriate

### HTTP Client Usage
- Use the existing `HttpClient` module for all API requests
- Don't create direct HTTP calls in client modules
- Follow the established pattern for request/response handling

### Example Client Implementation:
```elixir
defmodule AbacatepayElixirSdk.ExampleClient do
  @moduledoc """
  Client for Example operations.
  """
  alias AbacatepayElixirSdk.HttpClient

  @doc """
  Creates a new example resource.
  """
  def create(params) do
    case HttpClient.request(:post, "/example/create", body: Jason.encode!(params)) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}
      {:ok, %{body: %{"error" => error}}} ->
        {:error, error}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end
```

## Adding New Features

### New API Endpoints
1. Create a new client module in `lib/abacatepay_elixir_sdk/`
2. Follow the existing client pattern
3. Add comprehensive tests with VCR cassettes
4. Update the main module to expose the new client
5. Update documentation and README

### Breaking Changes
- Increment major version number
- Document migration path in CHANGELOG.md
- Add deprecation warnings before removing features
- Provide clear upgrade instructions

## Reporting Issues

### Bug Reports
Include:
- Elixir/Erlang versions
- SDK version
- Minimal code to reproduce the issue
- Expected vs actual behavior
- Stack trace (if applicable)

### Feature Requests
Include:
- Clear description of the feature
- Use case and benefits
- Proposed API design (if applicable)
- Willingness to implement

## Code Review Process

### For Contributors
- Respond to feedback promptly
- Make requested changes in separate commits
- Keep discussions focused and respectful
- Ask questions when feedback is unclear

### For Maintainers
- Review code for correctness, style, and design
- Test the changes locally
- Check documentation completeness
- Ensure backward compatibility
- Provide constructive feedback

## Release Process

1. Update version in `mix.exs`
2. Update `CHANGELOG.md`
3. Create release commit
4. Tag the release
5. Push to GitHub
6. Publish to Hex.pm
7. Update documentation

## Questions?

- Create an issue for general questions
- Join our Discord for real-time discussions
- Email dev@abacatepay.com for sensitive topics

Thank you for contributing to the AbacatePay Elixir SDK! 🎉
