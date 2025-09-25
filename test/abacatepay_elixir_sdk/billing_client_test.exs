defmodule AbacatepayElixirSdk.BillingClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.BillingClient

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "create/1" do
    test "creates a billing successfully" do
      use_cassette "billing_create_success" do
        params = %{
          amount: 1000,
          description: "Test billing",
          frequency: "oneTime"
        }

        assert {:ok, billing} = BillingClient.create(params)
        assert is_binary(billing.id)
        assert billing.url != nil
      end
    end

    test "handles error response" do
      use_cassette "billing_create_error" do
        params = %{invalid: "data"}

        assert {:error, _error} = BillingClient.create(params)
      end
    end
  end

  describe "list/0" do
    test "lists billings successfully" do
      use_cassette "billing_list_success" do
        assert {:ok, billings} = BillingClient.list()
        assert is_list(billings)
      end
    end
  end
end