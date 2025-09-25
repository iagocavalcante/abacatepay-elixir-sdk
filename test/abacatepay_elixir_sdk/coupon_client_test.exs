defmodule AbacatepayElixirSdk.CouponClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.CouponClient

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "create/1" do
    test "creates a coupon successfully" do
      use_cassette "coupon_create_success" do
        params = %{
          code: "TEST10",
          type: "percentage",
          value: 10,
          maxUses: 100,
          expiresAt: "2024-12-31T23:59:59Z",
          notes: "Test coupon for SDK"
        }

        assert {:ok, coupon} = CouponClient.create(params)
        assert is_binary(coupon["id"])
        assert coupon["code"] == "TEST10"
        assert coupon["type"] == "percentage"
        assert coupon["value"] == 10
      end
    end

    test "handles error response" do
      use_cassette "coupon_create_error" do
        params = %{invalid: "data"}

        assert {:error, _error} = CouponClient.create(params)
      end
    end
  end

  describe "list/0" do
    test "lists coupons successfully" do
      use_cassette "coupon_list_success" do
        assert {:ok, coupons} = CouponClient.list()
        assert is_list(coupons)
      end
    end
  end
end