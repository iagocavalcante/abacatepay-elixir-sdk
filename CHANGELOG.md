# Changelog

All notable changes to the AbacatePay Elixir SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-01-21

### Added
- **PublicMrrClient** - New client for Trust MRR Integration endpoints:
  - `get_mrr/0` - Get Monthly Recurring Revenue and active subscriptions
  - `get_merchant_info/0` - Get merchant name, website, and creation date
  - `get_revenue/2` - Get revenue metrics for a date range (1-hour cache)
- **Typed Response Structs** - All API responses now return typed structs:
  - `Customer` - Customer data with id, name, email, tax_id, cellphone
  - `Pix` - PIX QR code with id, amount, status, br_code, timestamps
  - `Coupon` - Discount coupon with code, discount, type, max_uses
  - `Store` - Store info with balance details
  - `Withdraw` - Withdrawal with pix_key, status
  - `Mrr` - Monthly recurring revenue metrics
  - `MerchantInfo` - Merchant information
  - `Revenue` - Revenue metrics for a period
- **Structured Error Handling** - New `Error` struct with:
  - `status` - HTTP status code
  - `code` - API error code
  - `message` - Human-readable error message
  - `details` - Additional error details
  - `String.Chars` implementation for easy logging
- **Response Module** - Centralized response parsing with:
  - Automatic struct conversion
  - HTTP status code handling (2xx, 4xx, 5xx)
  - Support for list responses with custom keys

### Changed
- All client modules now use `Response.parse/2` for consistent response handling
- `HttpClient.request/3` now supports `:params` option for query parameters (Req built-in)
- `HttpClient.request/3` now supports `:json` option for automatic JSON encoding
- Updated `Billing` struct with additional fields (status, timestamps)
- Improved documentation with struct-based examples

### Fixed
- Deprecated `preferred_cli_env` warning - moved to `cli/0` function

### Documentation
- Updated README with typed struct examples
- Added Error Handling section with pattern matching examples
- Added Data Structures table listing all available structs
- Added PublicMrrClient usage examples
- Updated all API examples to use struct responses

## [0.1.0] - 2025-09-25

### Added
- Initial release of AbacatePay Elixir SDK
- Complete API client implementation with all endpoints:
  - **BillingClient** - Create and list billing/invoices
  - **CustomerClient** - Customer management operations
  - **PixClient** - PIX QR code creation and payment handling
  - **CouponClient** - Discount coupon management
  - **WithdrawClient** - Withdrawal operations (production only)
  - **StoreClient** - Store details and balance information
- **HttpClient** - Robust HTTP client with automatic authentication
- Comprehensive error handling with structured responses
- VCR testing support with 19 pre-recorded API interactions
- Support for both sandbox and production environments
- Automatic request authentication with Bearer tokens
- JSON request/response handling with proper encoding
- Environment-based configuration system
- Complete test suite with ExUnit and ExVCR
- Production-ready security features:
  - Sensitive data filtering in logs
  - HTTPS-only API communication
  - Secure token management

### Dependencies
- `req ~> 0.5.10` - Modern HTTP client for Elixir
- `jason ~> 1.4` - JSON encoding/decoding
- `exvcr ~> 0.15` - VCR testing support (test only)
- `excoveralls ~> 0.18` - Test coverage reports (test only)

### Documentation
- Comprehensive README with usage examples
- API reference documentation
- Testing guide with VCR setup
- Configuration examples for development and production
- Error handling patterns and best practices

### Testing
- 18 test cases covering all client operations
- VCR cassettes for reliable offline testing
- Real API integration tests with development tokens
- Coverage for success and error scenarios
- Separate test configurations for different environments

[Unreleased]: https://github.com/iagocavalcante/abacatepay-elixir-sdk/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/iagocavalcante/abacatepay-elixir-sdk/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/iagocavalcante/abacatepay-elixir-sdk/releases/tag/v0.1.0
