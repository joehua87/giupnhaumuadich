# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :giupnhaumuadich,
  upload_dir: System.get_env("UPLOAD_DIR", "/Users/achilles/tmp"),
  ecto_repos: [Giupnhaumuadich.Repo]

config :giupnhaumuadich, Giupnhaumuadich.Repo,
  # types: Yum.PostgresTypes,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime_usec]

config :giupnhaumuadich_web,
  ecto_repos: [Giupnhaumuadich.Repo],
  generators: [context_app: :giupnhaumuadich]

# Configures the endpoint
config :giupnhaumuadich_web, GiupnhaumuadichWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7sEuoIhD2doGWjAm0OWRWuRTE52/Isunm31V2oXV9Dw4aSPLPCPgLoOCbZ7PJ0qb",
  render_errors: [view: GiupnhaumuadichWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Giupnhaumuadich.PubSub,
  live_view: [signing_salt: "T0lhxWh8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
