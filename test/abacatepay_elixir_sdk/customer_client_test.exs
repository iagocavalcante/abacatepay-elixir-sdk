defmodule AbacatepayElixirSdk.CustomerClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.CustomerClient
  alias AbacatepayElixirSdk.Customer

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "create/1" do
    test "creates a customer successfully" do
      use_cassette "customer_create_success" do
        params = %{
          name: "João Silva",
          email: "joao@example.com",
          cellphone: "11999999999",
          taxId: "11144477735"
        }

        assert {:ok, %Customer{} = customer} = CustomerClient.create(params)
        assert is_binary(customer.id)
        assert customer.name == "João Silva"
        assert customer.email == "joao@example.com"
      end
    end

    test "handles error response" do
      use_cassette "customer_create_error" do
        params = %{invalid: "data"}

        assert {:error, _error} = CustomerClient.create(params)
      end
    end
  end

  describe "list/0" do
    test "lists customers successfully" do
      use_cassette "customer_list_success" do
        assert {:ok, customers} = CustomerClient.list()
        assert is_list(customers)
      end
    end
  end
end
