# AbacatePay para Elixir

Receba pagamentos por PIX, boleto e cartão com a API v2 da AbacatePay. O SDK também oferece clientes para aplicações que usam a v1. [English](README.md)

## Instalação

O SDK exige Elixir 1.18 ou superior na série 1.x. Adicione a dependência do Hex ao `mix.exs` da sua aplicação e execute `mix deps.get`. A versão 0.3.0 inclui os clientes das APIs v1 e v2.

```elixir
{:abacatepay_elixir_sdk, "~> 0.3.0"}
```

## Configuração

Crie uma chave v2 no **Modo Teste** com as permissões das operações que vai usar. A chave determina o ambiente. A URL é `https://api.abacatepay.com/v2` tanto em teste quanto em produção. [Chaves de API e permissões](https://docs.abacatepay.com/pages/comecar/chaves-de-api)

```elixir
# config/runtime.exs
import Config

config :abacatepay_elixir_sdk,
  v2_api_token: System.fetch_env!("ABACATEPAY_V2_API_TOKEN")
```

Para consultar métricas pelo Public MRR, configure também `:public_mrr_token` com o token de leitura `mrr_…` do plugin. Essas consultas retornam dados de produção. [Public MRR](https://docs.abacatepay.com/pages/integracoes/public-mrr)

## Receber um PIX de R$ 19,99

Envie o valor em centavos. A resposta traz o código copia e cola em `brCode` e a imagem do QR Code em `brCodeBase64`. As chaves da resposta são strings. [Criar cobrança PIX](https://docs.abacatepay.com/pages/transparents/create)

```elixir
alias AbacatepayElixirSdk.V2.Transparents

{:ok, %{"data" => %{"id" => id, "brCode" => codigo}}} =
  Transparents.create(%{method: "PIX", data: %{amount: 1999}})
```

No Modo Teste, use o mesmo ID para simular o pagamento e consultar o resultado. [Simular pagamento](https://docs.abacatepay.com/pages/transparents/simulate-payment)

```elixir
{:ok, _} = Transparents.simulate_payment(id)
{:ok, %{"data" => %{"status" => "PAID"}}} = Transparents.check(id)
```

## Criar um checkout hospedado

Cadastre o produto uma vez. Em cada venda, passe o ID e a quantidade em `items` e encaminhe o comprador para a URL recebida. [Criar checkout](https://docs.abacatepay.com/pages/payment/create)

```elixir
alias AbacatepayElixirSdk.V2.{Checkouts, Products}

{:ok, %{"data" => %{"id" => produto_id}}} =
  Products.create(%{externalId: "guia", name: "Guia", price: 1999, currency: "BRL"})

{:ok, %{"data" => %{"url" => url_pagamento}}} =
  Checkouts.create(%{items: [%{id: produto_id, quantity: 1}], methods: ["PIX"]})
```

Para confirmar o pagamento no servidor, cadastre seu endpoint com `AbacatepayElixirSdk.V2.Webhooks.create/1`. Assine `checkout.completed` para o checkout hospedado ou `transparent.completed` para o transparente. Valide cada entrega antes de liberar o pedido. [Eventos](https://docs.abacatepay.com/pages/notificacoes/webhooks) · [Validação do webhook](https://docs.abacatepay.com/pages/notificacoes/seguranca)

## Paginação e erros

As funções da v2 retornam `{:ok, resposta}` ou `{:error, %AbacatepayElixirSdk.Error{}}`. Em listas paginadas, envie `pagination.next` como `after` para avançar. [Convenções da API](https://docs.abacatepay.com/pages/reference/introduction)

```elixir
alias AbacatepayElixirSdk.V2.Customers

{:ok, %{"data" => clientes, "pagination" => pagina}} = Customers.list(limit: 20)

if pagina["hasMore"] do
  Customers.list(limit: 20, after: pagina["next"])
end
```

O campo `error.status` contém o status HTTP quando há resposta do servidor. O campo `error.code` traz `MISSING_TOKEN` quando falta a credencial configurada e `NETWORK_ERROR` em falhas de transporte.

## Migrar da v1

Mantenha `:api_token` nas chamadas da v1 e configure `:v2_api_token` para os módulos em `AbacatepayElixirSdk.V2`. Ao migrar uma cobrança por QR Code, use `V2.Transparents.create/1`. Para sacar o saldo para o titular da loja, use `V2.Payouts.create/1`. A função `V2.Pix.send/1` envia dinheiro a terceiros. [Guia de migração por operação (em inglês)](guides/migrating-to-v2.md)

## Referência e testes

Gere a referência dos módulos com `mix docs --warnings-as-errors` e abra `doc/index.html`. Ali estão as funções de checkout, assinaturas, clientes, cupons, catálogo, saques, subcontas, extrato, webhooks e métricas. Para executar os testes locais com respostas simuladas, use `mix test`.

- [Guia de contribuição](CONTRIBUTING.md)
- [Histórico de mudanças](CHANGELOG.md)
- [Licença MIT](LICENSE)
