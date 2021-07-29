defmodule GiupnhaumuadichWeb.LiveHelpers do
  import Phoenix.LiveView
  alias GiupnhaumuadichWeb.Router.Helpers, as: Routes
  alias Giupnhaumuadich.Accounts
  alias Giupnhaumuadich.Accounts.User

  def assign_defaults(socket, session, required \\ true)

  def assign_defaults(socket, session, false) do
    assign_new(socket, :current_user, fn -> find_current_user(session) end)
  end

  def assign_defaults(socket, session, true) do
    socket = assign_new(socket, :current_user, fn -> find_current_user(session) end)

    case socket.assigns.current_user do
      %User{} ->
        socket

      _other ->
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: Routes.user_session_path(socket, :new))
    end
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end

  def format_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  def url_query_to_list_params(params) do
    limit = Map.get(params, "limit", 24)
    page = Map.get(params, "page", 1)
    order = Map.get(params, "order")
    filter = Map.drop(params, ["limit", "page"])
    %{filter: filter, paging: %{page: page, page_size: limit}, order: order}
  end

  def list_params_to_url_query(%{filter: filter, paging: %{page: page, page_size: page_size}}) do
    Map.merge(filter, %{"page" => page, "limit" => page_size})
    |> Enum.filter(&(elem(&1, 1) not in [nil, ""]))
    |> URI.encode_query()
  end

  def assets_path(conn, key) do
    if is_prod() do
      Routes.static_path(conn, "/assets/#{key}")
    else
      key = String.replace(key, ~r/\.js$/, ".ts")
      "https://localhost:3000/assets/#{key}"
    end
  end

  def is_prod do
    System.get_env("MIX_ENV") == "prod"
  end

  def ensure_nested_map(%Ecto.Association.NotLoaded{}), do: nil
  def ensure_nested_map(%DateTime{} = v), do: v
  def ensure_nested_map(%Decimal{} = v), do: v
  def ensure_nested_map(v) when is_list(v), do: Enum.map(v, &ensure_nested_map/1)

  def ensure_nested_map(v) when is_struct(v) do
    v |> Map.from_struct() |> Map.drop([:__meta__]) |> ensure_nested_map()
  end

  def ensure_nested_map(v) when is_map(v) do
    for {key, value} <- v, into: %{} do
      {key, ensure_nested_map(value)}
    end
  end

  def ensure_nested_map(v), do: v

  def nav_items(socket, current_user) do
    [
      %{
        image: Routes.static_path(socket, "/images/home.svg"),
        path: Routes.page_path(socket, :index),
        label: "Trang chủ"
      },
      %{
        image: Routes.static_path(socket, "/images/online.svg"),
        path: Routes.medical_consultation_path(socket, :show),
        label: "Tư vấn y tế"
      },
      %{
        image: Routes.static_path(socket, "/images/nurse.svg"),
        path: Routes.doctors_path(socket, :index),
        label: "Bác sĩ"
      },
      %{
        image: Routes.static_path(socket, "/images/agenda.svg"),
        path: Routes.posts_path(socket, :index),
        label: "Cẩm nang"
      },
      if current_user do
        %{
          image: Routes.static_path(socket, "/images/user.svg"),
          path: Routes.profile_path(socket, :show),
          label: "Tài khoản"
        }
      else
        %{
          image: Routes.static_path(socket, "/images/user.svg"),
          path: Routes.sign_in_path(socket, :show),
          label: "Đăng nhập"
        }
      end
    ]
  end
end
