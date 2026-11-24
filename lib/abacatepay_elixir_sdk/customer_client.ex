defmodule AbacatepayElixirSdk.CustomerClient do
  @moduledoc """
  V1 customer records. For v2, see `AbacatepayElixirSdk.V2.Customers`.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Customer

  @doc """
  Create a v1 customer. All four fields are required.

      alias AbacatepayElixirSdk.CustomerClient

      CustomerClient.create(%{
        name: "Ana Silva",
        email: "ana@example.com",
        cellphone: "(11) 99999-1234",
        taxId: "111.444.777-35"
      })
  """
  @spec create(map()) :: {:ok, Customer.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/customer/create", json: params)
    |> Response.parse(struct: Customer)
  end

  @doc "List v1 customers as `AbacatepayElixirSdk.Customer` structs."
  @spec list() :: {:ok, [Customer.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/customer/list")
    |> Response.parse(struct: Customer)
  end
end
