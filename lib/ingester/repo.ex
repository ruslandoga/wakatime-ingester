defmodule Ingester.Repo do
  use Ecto.Repo,
    otp_app: :ingester,
    adapter: Ecto.Adapters.Postgres
end
