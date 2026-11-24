# AbacatePay Elixir SDK

[![Hex.pm](https://img.shields.io/hexpm/v/abacatepay_elixir_sdk)](https://hex.pm/packages/abacatepay_elixir_sdk)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue)](https://hexdocs.pm/abacatepay_elixir_sdk)
[![License](https://img.shields.io/hexpm/l/abacatepay_elixir_sdk)](https://github.com/iagocavalcante/abacatepay-elixir-sdk/blob/main/LICENSE)

Elixir SDK for AbacatePay’s v2 payments API, with clients for existing v1 integrations. [AbacatePay](https://abacatepay.com/)

[Português (Brasil)](README.pt-BR.md)

## Installation

The SDK requires Elixir 1.18 or later in the 1.x series. Add the Hex dependency to your application's `mix.exs` and run `mix deps.get`.

```elixir
{:abacatepay_elixir_sdk, "~> 0.3.0"}
```

Version 0.3.0 includes both v1 and v2 clients, so existing applications can migrate one workflow at a time.

## Configuration

Create a v2 API key with the permissions your application needs. Use a test-mode key while developing. The key selects the environment and both environments use `https://api.abacatepay.com/v2`. [API keys and permissions](https://docs.abacatepay.com/pages/comecar/chaves-de-api)

```elixir
# config/runtime.exs
import Config

config :abacatepay_elixir_sdk,
  v2_api_token: System.fetch_env!("ABACATEPAY_V2_API_TOKEN")
```

Public MRR requires the separate read-only `mrr_…` token from the Public MRR plugin. For those endpoints, add `config :abacatepay_elixir_sdk, public_mrr_token: System.fetch_env!("ABACATEPAY_PUBLIC_MRR_TOKEN")` to `runtime.exs`. [Public MRR guide](https://docs.abacatepay.com/pages/integracoes/public-mrr)

## Create a PIX charge

Amounts are integers in Brazilian centavos. This creates a R$19.99 charge and returns the PIX copy-and-paste code. The API accepts camelCase field names in maps, including nested fields. [Transparent PIX checkout](https://docs.abacatepay.com/pages/transparents/create)

```elixir
alias AbacatepayElixirSdk.{Error, V2.Transparents}

result = Transparents.create(%{method: "PIX", data: %{amount: 1999}})

case result do
  {:ok, %{"data" => %{"brCode" => code}}} -> {:ok, code}
  {:error, %Error{} = error} -> {:error, error.message}
end
```

With a test-mode key, simulate a payment and check its status using the ID returned above. A credit-card or boleto charge can be retrieved with `Transparents.get(id)`. [Test mode](https://docs.abacatepay.com/pages/comecar/modo-teste)

```elixir
{:ok, %{"data" => %{"id" => id}}} = result
{:ok, _} = Transparents.simulate_payment(id)
{:ok, %{"data" => %{"status" => "PAID"}}} = Transparents.check(id)
```

## Create a hosted checkout

Register a product once and reuse its ID. The checkout response contains the URL for the buyer. [Hosted checkout](https://docs.abacatepay.com/pages/payment/create)

```elixir
alias AbacatepayElixirSdk.V2.{Checkouts, Products}

{:ok, %{"data" => %{"id" => product_id}}} =
  Products.create(%{externalId: "guide", name: "Guide", price: 1999, currency: "BRL"})

{:ok, %{"data" => %{"url" => checkout_url}}} =
  Checkouts.create(%{items: [%{id: product_id, quantity: 1}], methods: ["PIX"]})
```

To confirm payment on your server, register a webhook with `AbacatepayElixirSdk.V2.Webhooks.create/1`. Subscribe to `checkout.completed` for hosted payments or `transparent.completed` for transparent charges. Verify deliveries in your application's receiver before fulfilling an order. [Webhook events](https://docs.abacatepay.com/pages/notificacoes/webhooks) · [Webhook verification](https://docs.abacatepay.com/pages/notificacoes/seguranca)

## Pagination and errors

V2 functions return `{:ok, envelope}` with the original JSON keys or `{:error, %AbacatepayElixirSdk.Error{}}`. List responses include the server’s pagination metadata. Use `pagination.next` as `after` while `hasMore` is true. [API conventions](https://docs.abacatepay.com/pages/reference/introduction)

```elixir
alias AbacatepayElixirSdk.V2.Customers

{:ok, %{"data" => customers, "pagination" => page}} = Customers.list(limit: 20)

if page["hasMore"] do
  Customers.list(limit: 20, after: page["next"])
end
```

An API error carries the HTTP status and the server’s message. A transport failure carries the code `NETWORK_ERROR`. A missing v2 or Public MRR token returns `MISSING_TOKEN` before the SDK makes a request.

## V2 resources

All modules below are under `AbacatepayElixirSdk.V2`. The module documentation lists their functions, and the upstream reference describes the accepted fields. [AbacatePay API reference](https://docs.abacatepay.com/pages/reference/introduction)

| Modules | Operations |
| --- | --- |
| `Products`, `Customers`, `Coupons` | Manage catalog items, customer records and discounts |
| `Checkouts`, `PaymentLinks` | Create hosted checkouts and reusable links, look up payments and issue refunds |
| `Transparents` | Quote, create, inspect and refund transparent PIX, boleto or card charges as applicable |
| `Subscriptions`, `CustomerPortal` | Manage subscription checkouts, plan changes, usage and portal links |
| `Payouts`, `Pix`, `SubAccounts` | Withdraw to the store owner, send PIX to third parties and manage seller balances |
| `BankStatement`, `Stores` | Read transactions and store balances |
| `PublicMrr`, `Webhooks` | Read revenue metrics and manage webhook registrations |

## Migrating from v1

Keep `:api_token` for v1 and add `:v2_api_token` for the workflows you migrate. V2 returns string-keyed JSON envelopes. The migration guide maps each v1 operation to its v2 equivalent and shows how to update request payloads and response matching. [Migrate from v1 to v2](guides/migrating-to-v2.md)

## Testing

Run `mix test` to run the suite with fixtures and stubs. Run `mix docs --warnings-as-errors` and open `doc/index.html` for the SDK reference built from this checkout. The HexDocs badge points to the published release.

## Project

- [Contributor guide](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [Issue tracker](https://github.com/iagocavalcante/abacatepay-elixir-sdk/issues)
- [AbacatePay support](mailto:dev@abacatepay.com)
- [MIT license](LICENSE)
