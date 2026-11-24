defmodule AbacatepayElixirSdk.HttpClient do
  @moduledoc """
  Shared HTTP transport for AbacatePay. Direct requests default to API v1.

  Automatically sets base URL, Authorization header, and handles
  request/response processing.

  ## Usage

      # Simple GET request
      HttpClient.request(:get, "/store/get")

      # GET with query params
      HttpClient.request(:get, "/pixQrCode/check", params: [id: "abc123"])

      # GET a v1 withdrawal by external ID
      HttpClient.request(:get, "/withdraw/get", params: [externalId: "withdraw-123"])
  """

  @production_url "https://api.abacatepay.com/v1"

  @doc """
  Returns the base URL for API requests.
  """
  @spec base_url() :: String.t()
  def base_url do
    Application.get_env(:abacatepay_elixir_sdk, :base_url) || @production_url
  end

  @doc """
  Returns the default headers for API requests.
  """
  @spec default_headers(keyword()) :: [{String.t(), String.t()}]
  def default_headers(extra_headers \\ []) do
    default_headers(extra_headers, AbacatepayElixirSdk.api_token())
  end

  defp default_headers(extra_headers, api_key) do
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

    * `:base_url` - Server URL including the API version (defaults to the v1 URL)
    * `:api_token` - Bearer credential for this request (defaults to the configured v1 credential)
    * `:params` - Query parameters as a keyword list or map (uses Req's built-in support)
    * `:json` - Request body as a map (automatically JSON encoded by Req)
    * `:body` - Raw request body (for backwards compatibility)
    * `:headers` - Additional headers to merge with defaults

  ## Examples

      # GET with query params
      HttpClient.request(:get, "/pixQrCode/check", params: [id: "abc123"])

      # POST with JSON body
      HttpClient.request(:post, "/pixQrCode/create", json: %{amount: 1999})
  """
  @spec request(atom(), String.t(), keyword()) ::
          {:ok, Req.Response.t()} | {:error, Exception.t()}
  def request(method, path, opts \\ []) do
    {extra_headers, opts} = Keyword.pop(opts, :headers, [])
    {url, opts} = Keyword.pop_lazy(opts, :base_url, &base_url/0)
    {token, opts} = Keyword.pop_lazy(opts, :api_token, &AbacatepayElixirSdk.api_token/0)

    req_opts =
      [
        method: method,
        url: String.trim_trailing(url, "/") <> path,
        headers: default_headers(extra_headers, token)
      ] ++ opts

    Req.request(req_opts)
  end
end
