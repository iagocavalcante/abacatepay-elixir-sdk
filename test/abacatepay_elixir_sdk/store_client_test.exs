defmodule AbacatepayElixirSdk.StoreClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.StoreClient
  alias AbacatepayElixirSdk.Store

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "get/0" do
    test "gets store details successfully" do
      use_cassette "store_get_success" do
        assert {:ok, %Store{} = store} = StoreClient.get()
        assert is_binary(store.id)
        assert is_binary(store.name)
      end
    end
  end
end
