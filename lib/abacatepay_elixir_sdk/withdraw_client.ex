defmodule AbacatepayElixirSdk.WithdrawClient do
  @moduledoc """
  V1 withdrawals from the store balance. For v2, see `AbacatepayElixirSdk.V2.Payouts`.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Withdraw

  @doc """
  Request a v1 production withdrawal. Pass `method: "PIX"`, an `externalId`,
  the amount in centavos and a `pix` map containing `type` and `key`.
  """
  @spec create(map()) :: {:ok, Withdraw.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/withdraw/create", json: params)
    |> Response.parse(struct: Withdraw)
  end

  @doc "Get a v1 withdrawal by the external ID supplied when it was created."
  @spec get(String.t()) :: {:ok, Withdraw.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get(external_id) do
    HttpClient.request(:get, "/withdraw/get", params: [externalId: external_id])
    |> Response.parse(struct: Withdraw)
  end

  @doc "List v1 withdrawals as `AbacatepayElixirSdk.Withdraw` structs."
  @spec list() :: {:ok, [Withdraw.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/withdraw/list")
    |> Response.parse(struct: Withdraw)
  end
end
