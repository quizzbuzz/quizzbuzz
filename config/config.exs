# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :quizzbuzz,
  ecto_repos: [Quizzbuzz.Repo]

# Configures the endpoint
config :quizzbuzz, Quizzbuzz.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0bVOwOie1aosz/QCEitG/p13YE//+/fZ7J96pFdREKdzseFfoxhUovSGj2V7HOf0",
  render_errors: [view: Quizzbuzz.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Quizzbuzz.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :passport,
  resource: "#{binding[:module]}",
  repo: "#{binding[:base]}.Repo"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
