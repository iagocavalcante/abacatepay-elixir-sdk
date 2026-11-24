# Migrating from v1 to v2

You can migrate one workflow at a time. Existing client modules still read `:api_token` and call v1. The modules under `AbacatepayElixirSdk.V2` use a v2 key. Create that key in test mode with the permissions for the operations you plan to try. [API keys and permissions](https://docs.abacatepay.com/pages/comecar/chaves-de-api)

## Configure both versions

```elixir
# config/runtime.exs
import Config

config :abacatepay_elixir_sdk,
  api_token: System.fetch_env!("ABACATEPAY_API_TOKEN"),
  v2_api_token: System.fetch_env!("ABACATEPAY_V2_API_TOKEN")
```

If you use Public MRR, configure its read-only plugin token separately for v2. Public MRR returns production metrics even when your payment integration is in test mode. [Public MRR guide](https://docs.abacatepay.com/pages/integracoes/public-mrr)

```elixir
config :abacatepay_elixir_sdk,
  public_mrr_token: System.fetch_env!("ABACATEPAY_PUBLIC_MRR_TOKEN")
```

For a custom server, set `:base_url` for v1 and `:v2_base_url` for v2, including the version path. Both API versions use the key to identify the environment.

## Pick the equivalent call

In the table, `V2` means `AbacatepayElixirSdk.V2`. Query functions accept a keyword list or map. Create functions take maps with the API’s camelCase field names.

| V1 client and function | V2 call | What to change |
| --- | --- | --- |
| `BillingClient.create/1`, `list/0` | `V2.Checkouts.create/1`, `list/0,1` | For one-time billing, register products first and send `items: [%{id: product_id, quantity: 1}]`. For reusable links use `V2.PaymentLinks`. |
| `PixClient.create_qrcode/1` | `V2.Transparents.create/1` | Wrap the amount and other fields in `%{method: "PIX", data: params}`. Read the code from `data["brCode"]`. |
| `PixClient.check_status/1`, `simulate_payment/1,2` | `V2.Transparents.check(id)`, `simulate_payment(id)` | Simulation takes the charge ID and requires a test-mode key. Send charge metadata during creation. |
| `CustomerClient.create/1`, `list/0` | `V2.Customers.create/1`, `list/0,1` | Only `email` is required to create a v2 customer. Read the customer fields from `"data"`. |
| `CouponClient.create/1`, `list/0` | `V2.Coupons.create/1`, `list/0,1` | Send `code`, `discountKind`, `discount` and `maxRedeems`. For a 10% discount use `discountKind: "PERCENTAGE", discount: 1000`. |
| `WithdrawClient.create/1`, `get/1`, `list/0` | `V2.Payouts.create/1`, `get/1`, `list/0,1` | Send `amount`, `externalId` and `pix: %{type: ..., key: ...}`. To look up a withdrawal by your ID, use `V2.Payouts.get(externalId: external_id)`. |
| `StoreClient.get/0` | `V2.Stores.get/0` | Read the store and its balance from the string-keyed data map. |
| `PublicMrrClient.get_mrr/0`, `get_merchant_info/0`, `get_revenue/2` | `V2.PublicMrr.mrr/0`, `merchant_info/0`, `revenue/2` | Read the MRR in centavos from `data["mrr"]["value"]`. Pass dates as `YYYY-MM-DD` strings. |

For outbound transfers, `V2.Payouts.create/1` withdraws to the store owner’s PIX key. `V2.Pix.send/1` sends money from the balance to a third party. Incoming PIX charges use `V2.Transparents.create/1`. [Payouts](https://docs.abacatepay.com/pages/payouts/create) · [Outbound transfers](https://docs.abacatepay.com/pages/pix/create) · [PIX charges](https://docs.abacatepay.com/pages/transparents/create)

## Update response matching

A successful v1 client call returns a resource struct or list of structs. V2 preserves the decoded response envelope, including the cursor on paginated results. Both versions return `{:error, %AbacatepayElixirSdk.Error{}}` on request failures.

```elixir
alias AbacatepayElixirSdk.{Error, V2.Customers}

case Customers.get(email: "buyer@example.com") do
  {:ok, %{"data" => %{"id" => id}}} -> {:ok, id}
  {:error, %Error{status: 401, message: message}} -> {:error, {:authorization, message}}
  {:error, %Error{} = error} -> {:error, error}
end
```

For pagination, pass `page["next"]` as `:after` while `page["hasMore"]` is true. Keep the same date and resource filters between calls. Some successful actions, such as `V2.Webhooks.delete/1`, return `%{"success" => true}` without a `"data"` key. [Response and pagination conventions](https://docs.abacatepay.com/pages/reference/introduction)

## Recurring billing

Register a product with a billing cycle and create a subscription checkout for it. Send the buyer to the URL in the response. The checkout has a `bill_` ID. After payment, use the resulting `subs_` ID for subscription operations such as cancellation or a plan change. [Subscriptions](https://docs.abacatepay.com/pages/subscriptions/create)

```elixir
alias AbacatepayElixirSdk.V2.{Products, Subscriptions}

{:ok, %{"data" => %{"id" => plan_id}}} =
  Products.create(%{externalId: "monthly-guide", name: "Monthly guide",
                    price: 1999, currency: "BRL", cycle: "MONTHLY"})

{:ok, %{"data" => %{"url" => subscription_url}}} =
  Subscriptions.create(%{items: [%{id: plan_id, quantity: 1}], methods: ["CARD"]})
```
