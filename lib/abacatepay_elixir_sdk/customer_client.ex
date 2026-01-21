defmodule AbacatepayElixirSdk.CustomerClient do
  @moduledoc """
  Client for Customer operations.

  Provides functions to create and list customers.

  ## Examples

      # Create a customer
      params = %{name: "John Doe", email: "john@example.com", tax_id: "12345678901"}
      {:ok, %Customer{} = customer} = CustomerClient.create(params)

      # List all customers
      {:ok, customers} = CustomerClient.list()
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Customer

  @doc """
  Creates a new customer.

  ## Parameters

    * `params` - Map with the following keys:
      * `:name` (required) - Customer name
      * `:email` (required) - Customer email
      * `:tax_id` (optional) - Customer tax ID (CPF/CNPJ)
      * `:cellphone` (optional) - Customer cellphone
      * `:metadata` (optional) - Additional metadata

  ## Returns

    * `{:ok, %Customer{}}` - The created customer
    * `{:error, %Error{}}` - Error details

  ## Examples

      params = %{
        name: "John Doe",
        email: "john@example.com",
        tax_id: "12345678901"
      }
      {:ok, customer} = CustomerClient.create(params)
  """
  @spec create(map()) :: {:ok, Customer.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def create(params) do
    HttpClient.request(:post, "/customer/create", json: params)
    |> Response.parse(struct: Customer)
  end

  @doc """
  Lists all customers.

  ## Returns

    * `{:ok, [%Customer{}]}` - List of customers
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, customers} = CustomerClient.list()
      Enum.each(customers, fn c -> IO.puts(c.name) end)
  """
  @spec list() :: {:ok, [Customer.t()]} | {:error, AbacatepayElixirSdk.Error.t()}
  def list do
    HttpClient.request(:get, "/customer/list")
    |> Response.parse(struct: Customer)
  end
end
