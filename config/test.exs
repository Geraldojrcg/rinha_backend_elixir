import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rinha_backend, RinhaBackend.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "rinha_backend",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rinha_backend, RinhaBackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NT2DZH+MLo5PcXgj/fUYSHRKNiaLp/zNmf81NfktJAaFKNeIgjEQhfO6V2wqvwY+",
  server: false

# In test we don't send emails.
config :rinha_backend, RinhaBackend.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
