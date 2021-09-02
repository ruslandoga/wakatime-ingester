import Config

if config_env() in [:dev, :prod] do
  # Configure your database
  config :ingester, Ingester.Repo,
    url: System.get_env("DATABASE_URL") || "ecto://postgres:postgres@localhost:5433/db2",
    show_sensitive_data_on_connection_error: true,
    pool_size: 3

  config :ingester, IngesterWeb.Endpoint,
    http: [port: 5000],
    # debug_errors: true,
    # code_reloader: true,
    check_origin: false,
    server: true

  # Do not include metadata nor timestamps in development logs
  config :logger, :console, format: "[$level] $message\n"

  # Set a higher stacktrace during development. Avoid configuring such
  # in production as building large stacktraces may be expensive.
  config :phoenix, :stacktrace_depth, 20
end
