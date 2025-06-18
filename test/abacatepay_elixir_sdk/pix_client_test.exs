defmodule AbacatepayElixirSdk.PixClientTest do
  use ExUnit.Case

  test "create, simulate payment, and check status for pix qrcode via real API" do
    params = %{
      amount: 123,
      expiresIn: 123,
      description: "Pagamento Pix",
      customer: %{
        name: "Daniel Lima",
        cellphone: "(11) 4002-8922",
        email: "daniel_lima@abacatepay.com",
        taxId: "123.456.789-01"
      }
    }
    # Create QRCode
    {:ok, qrcode_data} = AbacatepayElixirSdk.PixClient.create_qrcode(params)
    assert is_map(qrcode_data)
    assert id = qrcode_data["id"]

    # Simulate payment
    result_sim = AbacatepayElixirSdk.PixClient.simulate_payment(id, %{})
    assert is_tuple(result_sim)

    # Check status
    result_status = AbacatepayElixirSdk.PixClient.check_status(id)
    assert is_tuple(result_status)
  end
end
