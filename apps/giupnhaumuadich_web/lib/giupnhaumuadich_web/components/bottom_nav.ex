defmodule GiupnhaumuadichWeb.Components.BottomNav do
  use Surface.Component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~F"""
    <nav class="bg-white h-16 w-full grid right-0 bottom-0 left-0 grid-cols-5 lg:hidden fixed">
      {#for %{image: image_src, path: path, label: label} <- items(@socket)}
        <LiveRedirect class="flex flex-col items-center justify-center" to={path}>
          <img src={image_src} class="h-6 w-6" />
          <span class="mt-1 text-xs block">{label}</span>
        </LiveRedirect>
      {/for}
    </nav>
    """
  end

  defp items(socket) do
    [
      %{
        image: Routes.static_path(socket, "/images/home.svg"),
        path: Routes.page_path(socket, :index),
        label: "Trang chủ"
      },
      %{
        image: Routes.static_path(socket, "/images/nurse.svg"),
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
      %{
        image: Routes.static_path(socket, "/images/user.svg"),
        path: Routes.user_session_path(socket, :new),
        label: "Tài khoản"
      }
    ]
  end
end
