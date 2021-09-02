defmodule IngesterWeb.IgnoreController do
  use IngesterWeb, :controller
  require Logger

  def ignore(conn, %{"logs" => logs}) do
    logs
    |> String.split("\n", trim: true)
    |> Enum.map(&Jason.decode!/1)
    |> Enum.each(fn %{"level" => level} = log -> Logger.log(log_level(level), log) end)

    send_resp(conn, 201, [])
  end

  defp log_level("debug"), do: :debug
  defp log_level("error"), do: :error
end
