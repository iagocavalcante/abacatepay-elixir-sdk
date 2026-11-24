defmodule AbacatepayElixirSdk.BillingClient do
  @moduledoc """
  V1 hosted billing client. Use `AbacatepayElixirSdk.V2.Checkouts` for one-time payments or `AbacatepayElixirSdk.V2.PaymentLinks` for reusable links.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Billing

  @doc """
  Create a v1 billing with inline products and redirect URLs.

      alias AbacatepayElixirSdk.BillingClient

      BillingClient.create(%{
        frequency: "ONE_TIME",
        methods: ["PIX"],
        products: [%{externalId: "guide", name: "Guide", quantity: 1, price: 1999}],
        returnUrl: "https://example.com/cart",
        completionUrl: "https://example.com/thanks"
      })
  """
  @spec create(map()) :: {:ok, Billing.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/billing/create", json: params)
    |> Response.parse(struct: Billing)
  end

  @doc "List v1 billings as `AbacatepayElixirSdk.Billing` structs."
  @spec list() :: {:ok, [Billing.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/billing/list")
    |> Response.parse(struct: Billing, list_key: "billings")
  end
end
