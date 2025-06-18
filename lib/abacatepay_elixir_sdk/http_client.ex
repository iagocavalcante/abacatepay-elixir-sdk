defmodule AbacatepayElixirSdk.HttpClient do
  @moduledoc """
  HTTP client for AbacatePay API using Req.
  Automatically sets base URL and Authorization header.
  """

  @production_url "https://api.abacatepay.com/v1"

  def base_url do
    Application.get_env(:abacatepay_elixir_sdk, :base_url) ||
      case AbacatepayElixirSdk.environment() do
        :production -> @production_url
        _ -> @production_url
      end
  end

  def process_request_headers(headers \\ []) do
    api_key = AbacatepayElixirSdk.api_token()
    version = Application.spec(:abacatepay_elixir_sdk, :vsn) || "dev"
    [
      {"content-type", "application/json"},
      {"accept", "application/json"},
      {"user-agent", "Abacatepay-Elixir/#{version}"},
      {"authorization", "Bearer #{api_key}"}
      | headers
    ]
  end

  @doc """
  Makes an HTTP request with the given method, path, and options.
  """
  def request(method, path, opts \\ []) do
    url = base_url() <> path
    req_opts = [
      method: method,
      url: url,
      headers: process_request_headers()
    ] ++ opts

    Req.request(req_opts)
  end
end
