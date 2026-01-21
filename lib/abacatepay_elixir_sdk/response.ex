defmodule AbacatepayElixirSdk.Response do
  @moduledoc """
  Shared response parsing for AbacatePay API responses.

  Provides consistent handling of API responses, including:
  - Success responses with data extraction
  - Error responses with structured error types
  - Automatic conversion of API responses to structs
  """

  alias AbacatepayElixirSdk.Error

  @type response :: {:ok, term()} | {:error, Error.t()}

  @doc """
  Parses an HTTP response and returns either success data or a structured error.

  ## Options

    * `:struct` - Module to convert the response data into
    * `:data_key` - Key to extract data from (default: "data")
    * `:list_key` - Key for list responses (e.g., "billings", "customers")

  ## Examples

      # Simple response
      Response.parse(response)

      # Convert to struct
      Response.parse(response, struct: Customer)

      # List response with custom key
      Response.parse(response, struct: Billing, list_key: "billings")
  """
  @spec parse(term(), keyword()) :: response()
  def parse(response, opts \\ [])

  # Success with status 2xx
  def parse({:ok, %{status: status, body: body}}, opts) when status in 200..299 do
    data = extract_data(body, opts)
    struct_module = opts[:struct]

    result =
      cond do
        is_nil(struct_module) ->
          data

        is_list(data) ->
          Enum.map(data, &to_struct(&1, struct_module))

        is_map(data) ->
          to_struct(data, struct_module)

        true ->
          data
      end

    {:ok, result}
  end

  # Client errors (4xx)
  def parse({:ok, %{status: status, body: body}}, _opts) when status in 400..499 do
    {:error, Error.from_response(body, status)}
  end

  # Server errors (5xx)
  def parse({:ok, %{status: status, body: body}}, _opts) when status in 500..599 do
    {:error, Error.from_response(body, status)}
  end

  # Other HTTP statuses
  def parse({:ok, %{status: status, body: body}}, _opts) do
    {:error, Error.from_response(body, status)}
  end

  # Network/connection errors
  def parse({:error, exception}, _opts) do
    {:error, Error.from_exception(exception)}
  end

  @doc """
  Converts a map with string keys to a struct.
  """
  @spec to_struct(map(), module()) :: struct()
  def to_struct(data, struct_module) when is_map(data) do
    atomized =
      for {k, v} <- data, into: %{} do
        key = if is_binary(k), do: to_safe_atom(k), else: k
        {key, v}
      end

    struct(struct_module, atomized)
  end

  defp extract_data(body, opts) when is_map(body) do
    data_key = opts[:data_key] || "data"
    list_key = opts[:list_key]

    cond do
      list_key && Map.has_key?(body, list_key) ->
        body[list_key]

      Map.has_key?(body, data_key) ->
        body[data_key]

      true ->
        body
    end
  end

  defp extract_data(body, _opts), do: body

  # Converts string to existing atom if it exists, otherwise creates new atom
  # This is safe because the keys come from API responses with known fields
  defp to_safe_atom(string) when is_binary(string) do
    # Convert camelCase to snake_case for Elixir conventions
    string
    |> Macro.underscore()
    |> String.to_atom()
  end
end
