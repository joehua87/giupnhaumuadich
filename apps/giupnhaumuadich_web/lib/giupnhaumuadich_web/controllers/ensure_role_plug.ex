defmodule GiupnhaumuadichWeb.EnsureRolePlug do
  import Plug.Conn
  alias Giupnhaumuadich.Accounts
  alias Giupnhaumuadich.Accounts.User
  alias Phoenix.Controller
  alias Plug.Conn

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  @doc false
  @spec call(Conn.t(), atom() | [atom()]) :: Conn.t()
  def call(conn, roles) do
    user_token = get_session(conn, :user_token)

    (user_token &&
       Accounts.get_user_by_session_token(user_token))
    |> has_role?(roles)
    |> maybe_halt(conn)
  end

  defp has_role?(%User{} = user, roles) when is_list(roles),
    do: Enum.any?(roles, &has_role?(user, &1))

  defp has_role?(%User{role: role}, role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorised")
    |> Controller.redirect(to: signed_in_path(conn))
    |> halt()
  end

  defp signed_in_path(_conn), do: "/"
end
