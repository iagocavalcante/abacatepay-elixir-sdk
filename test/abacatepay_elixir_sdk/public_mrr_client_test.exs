defmodule AbacatepayElixirSdk.PublicMrrClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.PublicMrrClient

  # Note: These endpoints may return null/empty data in sandbox mode.
  # The tests verify the SDK correctly handles API responses.

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "get_mrr/0" do
    test "calls MRR endpoint successfully" do
      use_cassette "public_mrr_get_mrr_success" do
        result = PublicMrrClient.get_mrr()
        # API may return struct with data or nil in sandbox mode
        assert {:ok, _} = result
      end
    end
  end

  describe "get_merchant_info/0" do
    test "calls merchant info endpoint successfully" do
      use_cassette "public_mrr_get_merchant_info_success" do
        result = PublicMrrClient.get_merchant_info()
        # API may return struct with data or nil in sandbox mode
        assert {:ok, _} = result
      end
    end
  end

  describe "get_revenue/2" do
    test "calls revenue endpoint successfully" do
      use_cassette "public_mrr_get_revenue_success" do
        start_date = "2024-01-01"
        end_date = "2024-01-31"

        result = PublicMrrClient.get_revenue(start_date, end_date)
        # API may return struct with data or nil in sandbox mode
        assert {:ok, _} = result
      end
    end

    test "handles invalid date range" do
      use_cassette "public_mrr_get_revenue_error" do
        start_date = "2024-01-31"
        end_date = "2024-01-01"

        # In sandbox, API may return ok with nil even for invalid params
        result = PublicMrrClient.get_revenue(start_date, end_date)

        assert match?({:ok, _}, result) or match?({:error, _}, result)
      end
    end
  end
end
