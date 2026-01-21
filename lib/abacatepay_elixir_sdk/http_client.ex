defmodule AbacatepayElixirSdk.HttpClient do
  @moduledoc """
  HTTP client for AbacatePay API using Req.

  Automatically sets base URL, Authorization header, and handles
  request/response processing.

  ## Usage

      # Simple GET request
      HttpClient.request(:get, "/store/get")

      # GET with query params
      HttpClient.request(:get, "/pixQrCode/check", params: [id: "abc123"])

      # POST with JSON body
      HttpClient.request(:post, "/billing/create", json: %{amount: 1000})
  """

  @production_url "https://api.abacatepay.com/v1"

  @doc """
  Returns the base URL for API requests.
  """
  @spec base_url() :: String.t()
  def base_url do
    Application.get_env(:abacatepay_elixir_sdk, :base_url) ||
      case AbacatepayElixirSdk.environment() do
        :production -> @production_url
        _ -> @production_url
      end
  end

  @doc """
  Returns the default headers for API requests.
  """
  @spec default_headers(keyword()) :: [{String.t(), String.t()}]
  def default_headers(extra_headers \\ []) do
    api_key = AbacatepayElixirSdk.api_token()
    version = Application.spec(:abacatepay_elixir_sdk, :vsn) || "dev"

    [
      {"content-type", "application/json"},
      {"accept", "application/json"},
      {"user-agent", "Abacatepay-Elixir/#{version}"},
      {"authorization", "Bearer #{api_key}"}
      | extra_headers
    ]
  end

  @doc """
  Makes an HTTP request with the given method, path, and options.

  ## Options

    * `:params` - Query parameters as a keyword list or map (uses Req's built-in support)
    * `:json` - Request body as a map (automatically JSON encoded by Req)
    * `:body` - Raw request body (for backwards compatibility)
    * `:headers` - Additional headers to merge with defaults

  ## Examples

      # GET with query params
      HttpClient.request(:get, "/pixQrCode/check", params: [id: "abc123"])

      # POST with JSON body
      HttpClient.request(:post, "/customer/create", json: %{name: "John", email: "john@example.com"})
  """
  @spec request(atom(), String.t(), keyword()) ::
          {:ok, Req.Response.t()} | {:error, Exception.t()}
  def request(method, path, opts \\ []) do
    {extra_headers, opts} = Keyword.pop(opts, :headers, [])

    req_opts =
      [
        method: method,
        url: base_url() <> path,
        headers: default_headers(extra_headers)
      ] ++ opts

    Req.request(req_opts)
  end
end
