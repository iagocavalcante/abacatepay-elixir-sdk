defmodule AbacatepayElixirSdk.PublicMrrClient do
  @moduledoc """
  Client for Public MRR (Monthly Recurring Revenue) operations.

  Provides functions to retrieve MRR metrics, merchant information, and revenue data.
  These endpoints are part of the Trust MRR Integration feature, allowing merchants
  to share revenue metrics transparently with stakeholders.

  **Note:** Results from the revenue endpoint are cached for 1 hour.

  ## Examples

      # Get MRR metrics
      {:ok, %Mrr{} = mrr} = PublicMrrClient.get_mrr()
      IO.puts("MRR: \#{mrr.mrr}, Active subs: \#{mrr.active_subscriptions}")

      # Get merchant info
      {:ok, %MerchantInfo{} = info} = PublicMrrClient.get_merchant_info()
      IO.puts("Store: \#{info.name}")

      # Get revenue for a period
      {:ok, %Revenue{} = revenue} = PublicMrrClient.get_revenue("2024-01-01", "2024-01-31")
  """

  alias AbacatepayElixirSdk.HttpClient
  alias AbacatepayElixirSdk.Response
  alias AbacatepayElixirSdk.Mrr
  alias AbacatepayElixirSdk.MerchantInfo
  alias AbacatepayElixirSdk.Revenue

  @doc """
  Gets the Monthly Recurring Revenue (MRR) and active subscriptions count.

  ## Returns

    * `{:ok, %Mrr{}}` - MRR metrics including revenue and subscription count
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, mrr} = PublicMrrClient.get_mrr()
      IO.puts("Monthly recurring revenue: R$ \#{mrr.mrr / 100}")
      IO.puts("Active subscriptions: \#{mrr.active_subscriptions}")
  """
  @spec get_mrr() :: {:ok, Mrr.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get_mrr do
    HttpClient.request(:get, "/public-mrr/mrr")
    |> Response.parse(struct: Mrr)
  end

  @doc """
  Gets basic merchant/store information.

  ## Returns

    * `{:ok, %MerchantInfo{}}` - Merchant information (name, website, creation date)
    * `{:error, %Error{}}` - Error details

  ## Examples

      {:ok, info} = PublicMrrClient.get_merchant_info()
      IO.puts("Store: \#{info.name}")
      IO.puts("Website: \#{info.website}")
      IO.puts("Created: \#{info.created_at}")
  """
  @spec get_merchant_info() :: {:ok, MerchantInfo.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get_merchant_info do
    HttpClient.request(:get, "/public-mrr/merchant-info")
    |> Response.parse(struct: MerchantInfo)
  end

  @doc """
  Gets revenue metrics for a specific period.

  **Note:** Results are cached for 1 hour by the API.

  ## Parameters

    * `start_date` - Start date in ISO 8601 format (e.g., "2024-01-01")
    * `end_date` - End date in ISO 8601 format (e.g., "2024-01-31")

  The end date must be after the start date.

  ## Returns

    * `{:ok, %Revenue{}}` - Revenue metrics including total revenue, transactions, and daily breakdown
    * `{:error, %Error{}}` - Error details

  ## Examples

      # Get revenue for January 2024
      {:ok, revenue} = PublicMrrClient.get_revenue("2024-01-01", "2024-01-31")
      IO.puts("Total revenue: R$ \#{revenue.total_revenue / 100}")
      IO.puts("Transactions: \#{revenue.total_transactions}")

      # Daily breakdown
      Enum.each(revenue.daily_breakdown, fn day ->
        IO.puts("\#{day["date"]}: R$ \#{day["amount"] / 100}")
      end)
  """
  @spec get_revenue(String.t(), String.t()) ::
          {:ok, Revenue.t()} | {:error, AbacatepayElixirSdk.Error.t()}
  def get_revenue(start_date, end_date) do
    HttpClient.request(:get, "/public-mrr/revenue",
      params: [startDate: start_date, endDate: end_date]
    )
    |> Response.parse(struct: Revenue)
  end
end
