defmodule AbacatepayElixirSdk.PublicMrrClient do
  @moduledoc """
  V1 Public MRR metrics. This client reads the plugin token from the shared v1 `:api_token` setting. To configure a separate metrics token alongside payment credentials, use `AbacatepayElixirSdk.V2.PublicMrr`.
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Mrr
  alias AbacatepayElixirSdk.MerchantInfo
  alias AbacatepayElixirSdk.Revenue

  @doc "Get v1 monthly recurring revenue. The current API returns the value in centavos inside the `mrr` map."
  @spec get_mrr() :: {:ok, Mrr.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get_mrr do
    HttpClient.request(:get, "/public-mrr/mrr")
    |> Response.parse(struct: Mrr)
  end

  @doc "Get the name, website and creation date of the merchant."
  @spec get_merchant_info() :: {:ok, MerchantInfo.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get_merchant_info do
    HttpClient.request(:get, "/public-mrr/merchant-info")
    |> Response.parse(struct: MerchantInfo)
  end

  @doc "Get revenue and transaction totals for a date range, using YYYY-MM-DD strings. The end date must follow the start date."
  @spec get_revenue(String.t(), String.t()) ::
          {:ok, Revenue.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get_revenue(start_date, end_date) do
    HttpClient.request(:get, "/public-mrr/revenue",
      params: [startDate: start_date, endDate: end_date]
    )
    |> Response.parse(struct: Revenue)
  end
end
