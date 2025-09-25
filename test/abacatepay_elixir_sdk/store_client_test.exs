defmodule AbacatepayElixirSdk.StoreClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.StoreClient

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "get/0" do
    test "gets store details successfully" do
      use_cassette "store_get_success" do
        assert {:ok, store} = StoreClient.get()
        assert Map.has_key?(store, "id")
        assert Map.has_key?(store, "name")
      end
    end
  end
end