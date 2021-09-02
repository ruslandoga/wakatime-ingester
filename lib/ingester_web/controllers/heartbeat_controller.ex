defmodule IngesterWeb.HeartbeatController do
  use IngesterWeb, :controller

  def create(conn, %{"_json" => heartbeats}) do
    :ok =
      heartbeats
      |> Enum.map(fn %{"time" => time, "user_agent" => user_agent} = hb ->
        ["wakatime/" <> _wakatime_version, os, _python_or_go_version, editor, _extension] =
          String.split(user_agent, " ")

        os = String.replace(os, ["(", ")"], "")

        %{hb | "time" => DateTime.from_unix!(round(time * 10_000_000), 10_000_000)}
        |> Map.delete("user_agent")
        |> Map.put("editor", editor)
        |> Map.put("operating_system", os)
        |> Map.update("is_write", nil, fn is_write -> !!is_write end)
      end)
      |> Ingester.insert_heartbeats()

    response =
      case heartbeats do
        heartbeats when is_list(heartbeats) ->
          %{"responses" => Enum.map(heartbeats, fn _ -> [nil, 201] end)}

        %{} = heartbeat ->
          %{"data" => heartbeat}
      end

    conn
    |> put_status(201)
    |> json(response)
  end
end
