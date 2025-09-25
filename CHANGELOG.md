# Changelog

All notable changes to the AbacatePay Elixir SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/iagocavalcante/abacatepay-elixir-sdk/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/iagocavalcante/abacatepay-elixir-sdk/releases/tag/v0.1.0
