defmodule GiupnhaumuadichWeb.Components.AdminNav do
  use Surface.Component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Router.Helpers, as: Routes

  prop current_user, :any

  def render(assigns) do
    ~F"""
    {#if @current_user}
      <nav class="container flex bg-gray-700 h-8 text-brand-100 items-center">
        <ul class="flex overflow-scroll">
          {#for %{to: to, label: label} <- items(@socket, @current_user)}
            <li class="flex-none">
              <LiveRedirect class="px-2 not-last:mr-2" to={to}>
                {label}
              </LiveRedirect>
            </li>
          {/for}
        </ul>
      </nav>
    {/if}
    """
  end

  defp items(socket, %{role: role}) do
    [
      if role in [:doctor, :moderator, :admin] do
        %{label: "Bệnh án", to: Routes.admin_medical_records_path(socket, :index)}
      end,
      if role in [:moderator, :admin] do
        %{label: "Chuyên khoa", to: Routes.admin_categories_path(socket, :index)}
      end,
      if role in [:moderator, :admin] do
        %{label: "Bác sĩ", to: Routes.admin_doctors_path(socket, :index)}
      end,
      if role in [:admin] do
        %{label: "Người dùng", to: Routes.admin_users_path(socket, :index)}
      end
    ]
    |> Enum.drop_while(&is_nil/1)
  end
end
