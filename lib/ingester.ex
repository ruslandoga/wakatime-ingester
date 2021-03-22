defmodule Ingester do
  @moduledoc """
  Ingester keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @spec insert_heartbeats([map]) :: :ok
  def insert_heartbeats(heartbeats) do
    Ingester.Repo.insert_all("heartbeats", heartbeats)
    :ok
  end
end
