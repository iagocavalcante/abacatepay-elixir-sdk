defmodule AbacatepayElixirSdk.V2.PublicMrr do
  @moduledoc """
  Read production revenue metrics using the Public MRR plugin token.

  [AbacatePay documentation](https://docs.abacatepay.com/pages/integracoes/public-mrr)
  """

  alias AbacatepayElixirSdk.V2

  @doc """
  Get public merchant information.

  [GET /v2/public-mrr/merchant-info](https://docs.abacatepay.com/pages/trustMRR/merchant-info)
  """
  @spec merchant_info() :: V2.result()
  def merchant_info() do
    V2.request(:get, "/public-mrr/merchant-info")
  end

  @doc """
  Get monthly recurring revenue and the active subscription count.

  [GET /v2/public-mrr/mrr](https://docs.abacatepay.com/pages/trustMRR/mrr)
  """
  @spec mrr() :: V2.result()
  def mrr() do
    V2.request(:get, "/public-mrr/mrr")
  end

  @doc """
  Get daily MRR for a date range in YYYY-MM-DD format.

  [GET /v2/public-mrr/mrr-by-day](https://docs.abacatepay.com/pages/trustMRR/mrr-by-day)
  """
  @spec mrr_by_day(String.t(), String.t()) :: V2.result()
  def mrr_by_day(start_date, end_date) do
    V2.request(:get, "/public-mrr/mrr-by-day", params: [startDate: start_date, endDate: end_date])
  end

  @doc """
  Get revenue and transaction counts for a date range in YYYY-MM-DD format.

  [GET /v2/public-mrr/revenue](https://docs.abacatepay.com/pages/trustMRR/revenue)
  """
  @spec revenue(String.t(), String.t()) :: V2.result()
  def revenue(start_date, end_date) do
    V2.request(:get, "/public-mrr/revenue", params: [startDate: start_date, endDate: end_date])
  end
end
