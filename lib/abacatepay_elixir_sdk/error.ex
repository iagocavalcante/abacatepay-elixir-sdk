defmodule AbacatepayElixirSdk.Error do
  @moduledoc """
  Structured error type for AbacatePay API errors.

  Provides consistent error handling with HTTP status codes and error details.

  ## Fields

    * `:status` - HTTP status code (e.g., 400, 401, 404, 500)
    * `:code` - API error code if provided (e.g., "INVALID_PARAMS", "UNAUTHORIZED")
    * `:message` - Human-readable error message
    * `:details` - Additional error details (optional)

  ## Examples

      case PixClient.create_qrcode(params) do
        {:ok, pix} -> # success
        {:error, %AbacatepayElixirSdk.Error{status: 401}} ->
          # Handle unauthorized
        {:error, %AbacatepayElixirSdk.Error{code: "INVALID_PARAMS", message: msg}} ->
          # Handle validation error with message
        {:error, %AbacatepayElixirSdk.Error{} = error} ->
          Logger.error("API error: \#{error}")
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
  def from_response(body, status \\ nil) when is_map(body) do
    %__MODULE__{
      status: status,
      code: body["code"] || body["error_code"],
      message: extract_message(body),
      details: body["details"] || body["errors"]
    }
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
