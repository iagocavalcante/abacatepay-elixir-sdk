defmodule AbacatepayElixirSdk.PixClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias AbacatepayElixirSdk.PixClient

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  describe "create_qrcode/1" do
    test "creates a PIX QR code successfully" do
      use_cassette "pix_create_qrcode_success" do
        params = %{
          amount: 1000,
          description: "Test PIX payment"
        }

        assert {:ok, qr_data} = PixClient.create_qrcode(params)
        assert is_binary(qr_data["qrCode"])
        assert is_binary(qr_data["paymentLink"])
        assert is_binary(qr_data["id"])
      end
    end

    test "handles error response" do
      use_cassette "pix_create_qrcode_error" do
        params = %{invalid: "data"}

        assert {:error, _error} = PixClient.create_qrcode(params)
      end
    end
  end

  describe "check_status/1" do
    test "checks PIX QR code status successfully" do
      use_cassette "pix_check_status_success" do
        qr_id = "test-qr-id"

        assert {:ok, status_data} = PixClient.check_status(qr_id)
        assert Map.has_key?(status_data, "status")
      end
    end
  end

  describe "simulate_payment/2" do
    test "simulates PIX payment successfully" do
      use_cassette "pix_simulate_payment_success" do
        qr_id = "test-qr-id"
        metadata = %{test: "data"}

        assert {:ok, payment_data} = PixClient.simulate_payment(qr_id, metadata)
        assert Map.has_key?(payment_data, "status")
      end
    end
  end
end