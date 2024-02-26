# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :postbox,
  ecto_repos: [Postbox.Repo],
  generators: [timestamp_type: :utc_datetime]

config :postbox, Postbox.Repo, migration_primary_key: [type: :uuid]

# Configures the endpoint
config :postbox, PostboxWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PostboxWeb.ErrorHTML, json: PostboxWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Postbox.PubSub,
  live_view: [signing_salt: "Q/E868Q8"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :postbox, Postbox.Mailer, adapter: Swoosh.Adapters.Local

# Configure Stripity Stripe
config :stripity_stripe, :pool_options,
  timeout: 5_000,
  max_connections: 10

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  postbox: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.54.5",
  default: [
    args: ~w(sass/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
env_secrets = Path.join([__DIR__, "#{Mix.env()}.secret.exs"])
if File.exists?(env_secrets), do: import_config("#{Mix.env()}.secret.exs")
