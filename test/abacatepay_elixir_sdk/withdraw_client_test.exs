defmodule AbacatepayElixirSdk.WithdrawClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.WithdrawClient

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "create/1" do
    @tag :skip
    test "creates a withdraw successfully" do
      use_cassette "withdraw_create_success" do
        params = %{
          amount: 10000,
          externalId: "withdraw-test-1",
          bankAccount: %{
            bank: "001",
            agency: "1234",
            account: "12345678",
            accountType: "checking"
          }
        }

        assert {:ok, withdraw} = WithdrawClient.create(params)
        assert is_binary(withdraw["id"])
        assert withdraw["amount"] == 10000
      end
    end

    test "handles error response" do
      use_cassette "withdraw_create_error" do
        params = %{invalid: "data"}

        assert {:error, _error} = WithdrawClient.create(params)
      end
    end
  end

  describe "get/1" do
    @tag :skip
    test "gets a withdraw successfully" do
      use_cassette "withdraw_get_success" do
        external_id = "withdraw-test-1"

        assert {:ok, withdraw} = WithdrawClient.get(external_id)
        assert Map.has_key?(withdraw, "id")
        assert Map.has_key?(withdraw, "status")
      end
    end
  end

  describe "list/0" do
    @tag :skip
    test "lists withdraws successfully" do
      use_cassette "withdraw_list_success" do
        assert {:ok, withdraws} = WithdrawClient.list()
        assert is_list(withdraws)
      end
    end
  end
end