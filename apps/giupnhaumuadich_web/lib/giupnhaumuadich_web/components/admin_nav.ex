defmodule GiupnhaumuadichWeb.Components.AdminNav do
  use Surface.Component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~F"""
      <nav class="container flex bg-gray-700 h-8 text-brand-100 items-center">
        <ul class="flex overflow-scroll">
          {#for %{to: to, label: label} <- items(@socket)}
            <li class="flex-none">
              <LiveRedirect class="px-2 not-last:mr-2" to={to}>
                {label}
              </LiveRedirect>
            </li>
          {/for}
        </ul>
      </nav>
    """
  end

  defp items(socket) do
    [
      %{label: "Bệnh án", to: Routes.admin_medical_records_path(socket, :index)},
      %{label: "Người dùng", to: Routes.admin_users_path(socket, :index)},
      %{label: "Chuyên khoa", to: Routes.admin_categories_path(socket, :index)},
      %{label: "Bác sĩ", to: Routes.admin_doctors_path(socket, :index)}
    ]
  end
end
