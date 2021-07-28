defmodule GiupnhaumuadichWeb.Components.BottomNav do
  use Surface.Component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.Icon
  alias GiupnhaumuadichWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~F"""
    <nav class="bg-brand-700 h-16 text-white w-full grid right-0 bottom-0 left-0 grid-cols-5 lg:hidden fixed">
      {#for %{icon: icon, path: path, label: label} <- items(@socket)}
        <LiveRedirect class="flex flex-col items-center justify-center" to={path}>
          <Icon icon={icon} />
          <span class="text-xs">{label}</span>
        </LiveRedirect>
      {/for}
    </nav>
    """
  end

  defp items(socket) do
    [
      %{icon: "home", path: Routes.page_path(socket, :index), label: "Trang chủ"}
    ]
  end
end
