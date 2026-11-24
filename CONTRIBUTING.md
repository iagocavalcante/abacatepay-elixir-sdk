# Contributing to the AbacatePay Elixir SDK

## Run the project locally

Use Elixir 1.18 or later in the 1.x series with a compatible Erlang/OTP release. Clone your fork, then run these commands in the SDK directory. The suite uses synthetic credentials, recorded fixtures and Req adapters.

```sh
mix deps.get
mix test
```

To exercise a single v2 workflow, run `mix test test/abacatepay_elixir_sdk/v2_test.exs`. For a manual integration with an AbacatePay test-mode account, configure the application that uses the SDK. [Runtime configuration](README.md#configuration)

## Add or update an API operation

1. Check the HTTP method, path, required fields, and whether each argument belongs in the query or JSON body. Some POST operations take their ID in the query. [Upstream OpenAPI specification](https://docs.abacatepay.com/openapi.yaml)
2. Add the public function to the matching resource in `lib/abacatepay_elixir_sdk/v2/`. Use the existing `V2.request/3` helper, camelCase API keys, a typespec, and a docstring linking to the upstream operation. Keep the v1 clients compatible with their current callers.
3. Test a call through the public resource function. Assert the method, URL, query or JSON body, and the result the application sees. Include pagination or an error response when the contract changes.
4. Update the changelog and any affected examples in both READMEs or the migration guide. A new module belongs in the v2 module index as well.

For example, `V2.Coupons.delete/1` sends `id` as a query parameter. `V2.Coupons.toggle/1` sends it as JSON. Both use POST. The resource functions demonstrate how to express that difference. [Delete a coupon](https://docs.abacatepay.com/pages/coupons/delete) · [Toggle a coupon](https://docs.abacatepay.com/pages/coupons/toggle)

## Test fixtures

The v2 tests use a Req adapter to inspect outgoing requests. The hosted checkout test also replays two requests from the `v2_hosted_checkout` ExVCR cassette. Use synthetic IDs, customer details and credentials in new fixtures. Match on the request body when it matters and use `strict_mode: true` to fail if the cassette has no matching request. The test helper filters authorization headers during recording.

## Check a change

```sh
mix format --check-formatted
mix compile --warnings-as-errors
mix test --warnings-as-errors
mix docs --warnings-as-errors
```

Open `doc/index.html` to review examples, links and the v1 and v2 API sections. In a pull request, describe the affected workflow, link the upstream contract, and report the checks you ran. Include the SDK, Elixir and OTP versions when reporting a bug.

## Prepare a release

Update the package version in `mix.exs`, move the changelog entries from **Unreleased** to the dated version, and update the installation examples in both READMEs. Run the checks above and `mix hex.build` to inspect the package locally. Include the READMEs, migration guide, contributor guide, changelog and license. After the release commit is tagged and pushed, publish the package and its documentation through the maintainer’s Hex account. Verify the published installation instructions and HexDocs links.

Report issues on GitHub. Send private support requests to AbacatePay. [Issue tracker](https://github.com/iagocavalcante/abacatepay-elixir-sdk/issues) · [AbacatePay support](mailto:dev@abacatepay.com)
