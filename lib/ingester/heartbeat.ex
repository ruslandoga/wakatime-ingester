defmodule Ingester.Heartbeat do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:time, :utc_datetime, []}
  schema "heartbeats" do
    field :entity, :string
    field :type, :string
    field :category, :string
    field :project, :string
    field :branch, :string
    field :language, :string
    field :dependencies, {:array, :string}
    field :lines, :integer
    field :lineno, :integer
    field :cursorpos, :integer
    field :is_write, :boolean
    field :editor, :string
    field :operating_system, :string
  end
end
