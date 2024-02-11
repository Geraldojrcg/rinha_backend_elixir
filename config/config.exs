# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rinha_backend,
  ecto_repos: [RinhaBackend.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :rinha_backend, RinhaBackendWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: RinhaBackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RinhaBackend.PubSub,
  live_view: [signing_salt: "yPw2GDqM"],
  server: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
