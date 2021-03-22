# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ingester,
  ecto_repos: [Ingester.Repo]

# Configures the endpoint
config :ingester, IngesterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ac8JpWvqZdyyzpdHFhejH1Qa6BpoI3CzAY0cx4J6zhq1Ufyt+Ncpu8sPW/6stEGr",
  render_errors: [view: IngesterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Ingester.PubSub,
  live_view: [signing_salt: "6rn873vm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
