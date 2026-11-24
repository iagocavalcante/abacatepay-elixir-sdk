defmodule AbacatepayElixirSdk.Error do
  @moduledoc """
  Structured error type for AbacatePay API errors.

  Provides consistent error handling with HTTP status codes and error details.

  ## Fields

    * `:status` - HTTP status code (e.g., 400, 401, 404, 500)
    * `:code` - API error code if provided (e.g., "INVALID_PARAMS", "UNAUTHORIZED")
    * `:message` - Human-readable error message
    * `:details` - Additional error details (optional)

  For v2 calls, `MISSING_TOKEN` indicates a missing credential and `NETWORK_ERROR`
  indicates a transport failure. In both cases, `status` is `nil`.

  ## Example

      alias AbacatepayElixirSdk.{Error, V2.Stores}

      case Stores.get() do
        {:ok, %{"data" => store}} -> {:ok, store}
        {:error, %Error{status: 401, message: message}} -> {:error, {:authorization, message}}
        {:error, %Error{} = error} -> {:error, error}
      end
  """

  @type t :: %__MODULE__{
          status: integer() | nil,
          code: String.t() | nil,
          message: String.t(),
          details: map() | nil
        }

  defstruct [:status, :code, :message, :details]

  @doc """
  Creates an error from an API response body.
  """
  def from_response(body, status \\ nil)

  def from_response(body, status) when is_map(body) do
    %__MODULE__{
      status: status,
      code: body["code"] || body["error_code"],
      message: extract_message(body),
      details: body["details"] || body["errors"]
    }
  end

  def from_response(_body, status) do
    %__MODULE__{status: status, message: "Unexpected response from AbacatePay"}
  end

  @doc """
  Creates an error from a network/connection failure.
  """
  def from_exception(%{reason: reason}) do
    %__MODULE__{
      status: nil,
      code: "NETWORK_ERROR",
      message: format_reason(reason),
      details: nil
    }
  end

  def from_exception(error) when is_exception(error) do
    %__MODULE__{
      status: nil,
      code: "NETWORK_ERROR",
      message: Exception.message(error),
      details: nil
    }
  end

  defp extract_message(%{"error" => error}) when is_binary(error), do: error
  defp extract_message(%{"error" => %{"message" => msg}}), do: msg
  defp extract_message(%{"message" => msg}), do: msg
  defp extract_message(%{"error_message" => msg}), do: msg
  defp extract_message(_), do: "Unknown error"

  defp format_reason(reason) when is_atom(reason), do: Atom.to_string(reason)
  defp format_reason(reason) when is_binary(reason), do: reason
  defp format_reason(reason), do: inspect(reason)

  defimpl String.Chars do
    def to_string(%AbacatepayElixirSdk.Error{code: code, message: message, status: status}) do
      parts = []
      parts = if status, do: ["status=#{status}" | parts], else: parts
      parts = if code, do: ["code=#{code}" | parts], else: parts
      parts = ["message=\"#{message}\"" | parts]

      "AbacatepayElixirSdk.Error<#{Enum.join(Enum.reverse(parts), ", ")}>"
    end
  end
end
