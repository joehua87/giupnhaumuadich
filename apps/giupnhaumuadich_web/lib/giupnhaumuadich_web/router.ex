defmodule GiupnhaumuadichWeb.Router do
  use GiupnhaumuadichWeb, :router

  import GiupnhaumuadichWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GiupnhaumuadichWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GiupnhaumuadichWeb do
    pipe_through :api
  end

  scope "/", GiupnhaumuadichWeb do
    pipe_through :browser

    post "/upload", UploadController, :create
    get "/upload/:id", UploadController, :get

    live "/", PageLive, :index
    live "/tu-van-y-te", MedicalConsultationLive, :show
    live "/chuyen-khoa/:slug", CategoryLive, :show
    live "/tro-giup-y-te", MedicalHelpLive, :index
    live "/bac-si", DoctorsLive, :index
    live "/bac-si/:slug", DoctorLive, :show
    live "/bai-viet", PostsLive, :index
    live "/bai-viet/:slug", PostLive, :show
    live "/tim-kiem", SearchLive, :index
    live "/chu-de/:slug", TopicLive, :show
    live "/benh-an/:id", PublicMedicalRecordLive, :show
  end

  scope "/admin", GiupnhaumuadichWeb do
    pipe_through :browser

    live "/benh-an", AdminMedicalRecordsLive, :index
    live "/benh-an/:id", AdminMedicalRecordLive, :show
    live "/users", AdminUsersLive, :index
    live "/categories", AdminCategoriesLive, :index
    live "/categories/edit/:id", AdminCategoriesLive, :edit
    live "/doctors", AdminDoctorsLive, :index
    live "/doctors/edit/:id", AdminDoctorsLive, :edit
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

  ## Authentication routes

  scope "/", GiupnhaumuadichWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    post "/auth/facebook", AuthController, :facebook

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", GiupnhaumuadichWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", GiupnhaumuadichWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
