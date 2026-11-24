defmodule AbacatepayElixirSdk.V2.Webhooks do
  @moduledoc """
  Manage webhook endpoints and event subscriptions.

  Register a public HTTPS endpoint to receive payment confirmations. Supply a
  random secret of at least 32 characters and the events your application handles.

      alias AbacatepayElixirSdk.V2.Webhooks

      Webhooks.create(%{
        name: "Payment confirmations",
        endpoint: "https://example.com/webhooks/abacatepay",
        secret: System.fetch_env!("ABACATEPAY_WEBHOOK_SECRET"),
        events: ["checkout.completed", "transparent.completed"]
      })

  Your application's receiver checks the shared secret and verifies the signature
  over the raw request body before it acts on an event. [Webhook verification](https://docs.abacatepay.com/pages/notificacoes/seguranca)

  [AbacatePay documentation](https://docs.abacatepay.com/pages/notificacoes/webhooks)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Register a webhook URL and its events.

  [POST /v2/webhooks/create](https://docs.abacatepay.com/pages/webhooks/create)
  """
  @spec create(map()) :: V2.result()
  def create(params) do
    V2.request(:post, "/webhooks/create", json: params)
  end

  @doc """
  Fetch a webhook by ID.

  [GET /v2/webhooks/get](https://docs.abacatepay.com/pages/webhooks/get)
  """
  @spec get(String.t()) :: V2.result()
  def get(id) do
    V2.request(:get, "/webhooks/get", params: [id: id])
  end

  @doc """
  List webhook registrations with optional filters and pagination.

  [GET /v2/webhooks/list](https://docs.abacatepay.com/pages/webhooks/list)
  """
  @spec list(V2.query()) :: V2.result()
  def list(query \\ []) do
    V2.request(:get, "/webhooks/list", params: query)
  end

  @doc """
  Remove a webhook and discard its pending deliveries.

  [POST /v2/webhooks/delete](https://docs.abacatepay.com/pages/webhooks/delete)
  """
  @spec delete(String.t()) :: V2.result()
  def delete(id) do
    V2.request(:post, "/webhooks/delete", params: [id: id])
  end
end
