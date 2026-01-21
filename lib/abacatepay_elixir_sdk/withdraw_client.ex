defmodule AbacatepayElixirSdk.WithdrawClient do
  @moduledoc """
  Client for Withdraw operations.

  Provides functions to create, get, and list withdrawals.

  **Note:** Withdrawals are only available in production environment.

  ## Examples

      # Create a withdrawal
      params = %{amount: 10000, pix_key: "email@example.com", pix_key_type: "EMAIL"}
      {:ok, %Withdraw{} = withdraw} = WithdrawClient.create(params)

      # Get withdrawal status
      {:ok, withdraw} = WithdrawClient.get("external_123")

      # List all withdrawals
      {:ok, withdrawals} = WithdrawClient.list()
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Withdraw

  @doc """
  Creates a new withdrawal.

  **Note:** Only available in production environment.

  ## Parameters

    * `params` - Map with the following keys:
      * `:amount` (required) - Withdrawal amount in cents
      * `:pix_key` (required) - PIX key for destination
      * `:pix_key_type` (required) - Type of PIX key ("CPF", "CNPJ", "EMAIL", "PHONE", "RANDOM")
      * `:external_id` (optional) - External identifier

  ## Returns

    * `{:ok, %Withdraw{}}` - The created withdrawal
    * `{:error, %Error{}}` - Error details

  ## Examples

      params = %{
        amount: 50000,  # R$ 500.00
        pix_key: "12345678901",
        pix_key_type: "CPF",
        external_id: "withdraw_001"
      }
      {:ok, withdraw} = WithdrawClient.create(params)
  """
  @spec create(map()) :: {:ok, Withdraw.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/withdraw/create", json: params)
    |> Response.parse(struct: Withdraw)
  end

  @doc """
  Gets a specific withdrawal by external ID.

  ## Parameters

    * `external_id` - External identifier of the withdrawal

  ## Returns

    * `{:ok, %Withdraw{}}` - The withdrawal details
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, withdraw} = WithdrawClient.get("external_123")
      IO.puts("Status: \#{withdraw.status}")
  """
  @spec get(String.t()) :: {:ok, Withdraw.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get(external_id) do
    HttpClient.request(:get, "/withdraw/get", params: [externalId: external_id])
    |> Response.parse(struct: Withdraw)
  end

  @doc """
  Lists all withdrawals.

  ## Returns

    * `{:ok, [%Withdraw{}]}` - List of withdrawals
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, withdrawals} = WithdrawClient.list()
      completed = Enum.filter(withdrawals, & &1.status == "COMPLETED")
  """
  @spec list() :: {:ok, [Withdraw.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/withdraw/list")
    |> Response.parse(struct: Withdraw)
  end
end
