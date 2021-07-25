defmodule Giupnhaumuadich.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Giupnhaumuadich.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Giupnhaumuadich.PubSub},
      {Mongo, name: :mongo, url: "mongodb://docker:27017/giupnhaumuadich", pool_size: 3}

      # Start a worker by calling: Giupnhaumuadich.Worker.start_link(arg)
      # {Giupnhaumuadich.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Giupnhaumuadich.Supervisor)
  end
end
