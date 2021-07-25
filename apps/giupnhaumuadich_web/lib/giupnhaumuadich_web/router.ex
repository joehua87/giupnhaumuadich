defmodule GiupnhaumuadichWeb.Router do
  use GiupnhaumuadichWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GiupnhaumuadichWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GiupnhaumuadichWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/chuyen-khoa/:slug", CategoryLive, :show
    live "/bac-si", DoctorsLive, :index
    live "/bac-si/:slug", DoctorLive, :show
    live "/bai-viet", PostsLive, :index
    live "/bai-viet/:slug", PostLive, :show
    live "/tim-kiem", SearchLive, :index
    live "/chu-de/:slug", TopicLive, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", GiupnhaumuadichWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: GiupnhaumuadichWeb.Telemetry
      get "/node_modules/*path", GiupnhaumuadichWeb.RedirectController, :get
    end
  end
end
