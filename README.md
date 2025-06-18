# AbacatepayElixirSdk

SDK Elixir para integração com a API da [AbacatePay](https://abacatepay.com/).

## Instalação

Adicione ao seu `mix.exs`:

```elixir
def deps do
  [
    {:abacatepay_elixir_sdk, "~> 0.1.0"}
  ]
end
```

Depois rode:
```sh
mix deps.get
```

## Configuração

No seu `config/config.exs`:

```elixir
config :abacatepay_elixir_sdk,
  api_token: System.get_env("ABACATEPAY_TOKEN"),
  environment: :sandbox # ou :production
```

## Exemplos de Uso

### Cobranças (Billing)

```elixir
alias AbacatepayElixirSdk.BillingClient

# Listar cobranças
{:ok, billings} = BillingClient.list()

# Criar cobrança
params = %{
  frequency: "ONE_TIME",
  methods: ["PIX"],
  products: [
    %{
      external_id: "abc_123",
      name: "Produto A",
      description: "Descrição do produto A",
      quantity: 1,
      price: 100
    }
  ],
  metadata: %{},
  customer: %{
    name: "Cliente Teste",
    cellphone: "(11) 99999-9999",
    email: "cliente@teste.com",
    taxId: "123.456.789-00"
  }
}
BillingClient.create(params)
```

### Clientes (Customer)

```elixir
alias AbacatepayElixirSdk.CustomerClient

# Criar cliente
params = %{
  name: "Cliente Teste",
  cellphone: "(11) 99999-9999",
  email: "cliente@teste.com",
  taxId: "123.456.789-00"
}
CustomerClient.create(params)
```

### Pix QRCode

```elixir
alias AbacatepayElixirSdk.PixClient

# Criar QRCode Pix
params = %{
  amount: 123,
  expiresIn: 300,
  description: "Pagamento Pix",
  customer: %{
    name: "Cliente Teste",
    cellphone: "(11) 99999-9999",
    email: "cliente@teste.com",
    taxId: "123.456.789-00"
  }
}
{:ok, qrcode} = PixClient.create_qrcode(params)

# Simular pagamento (apenas em dev mode)
PixClient.simulate_payment(qrcode["id"], %{})

# Checar status
PixClient.check_status(qrcode["id"])
```

### Cupons (Coupon)

```elixir
alias AbacatepayElixirSdk.CouponClient

# Criar cupom
params = %{
  code: "DESCONTO20",
  notes: "Cupom de desconto para clientes",
  maxRedeems: 10,
  discountKind: "PERCENTAGE",
  discount: 20,
  metadata: %{}
}
CouponClient.create(params)

# Listar cupons
CouponClient.list()
```

## Testes

- Os testes de integração utilizam a API real. Certifique-se de ter um token válido e ambiente configurado.
- Para rodar os testes:

```sh
mix test
```

## Dúvidas?

Consulte a [documentação oficial da AbacatePay](https://docs.abacatepay.com/) para detalhes de cada endpoint.

---

Feito com 💚 para devs Elixir.

