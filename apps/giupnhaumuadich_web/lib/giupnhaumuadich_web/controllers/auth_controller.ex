defmodule GiupnhaumuadichWeb.AuthController do
  use GiupnhaumuadichWeb, :controller
  alias Giupnhaumuadich.Accounts
  alias GiupnhaumuadichWeb.UserAuth

  def facebook(conn, %{"access_token" => access_token}) do
    login_facebook(conn, access_token)
  end

  def facebook(conn, %{"user" => %{"access_token" => access_token}}) do
    login_facebook(conn, access_token)
  end

  def facebook_data_deletion(conn, _params) do
    json(conn, %{ok: 1})
  end

  def login_facebook(conn, access_token) do
    querystring = URI.encode_query(%{"access_token" => access_token})
    url = "https://graph.facebook.com/v11.0/me?#{querystring}"
    headers = [{"user-agent", "giupnhaumuadich.org"}]

    with {:ok, %{status: 200, body: body}} <-
           Finch.build(:get, url, headers) |> Finch.request(MyFinch),
         {:ok, %{"id" => _} = params} <- Jason.decode(body),
         {:ok, user} <- authenticate(:facebook, params) do
      UserAuth.log_in_user(conn, user)
    else
      _ -> render(conn, "new.html", error_message: "Invalid credentials")
    end
  end

  def authenticate(:facebook, %{"id" => id, "name" => name}) do
    email = "#{id}@facebook.com"
    password = id

    if v = Accounts.get_user_by_email_and_password(email, password) do
      {:ok, v}
    else
      Accounts.register_user(%{email: email, password: password, name: name})
    end
  end
end
