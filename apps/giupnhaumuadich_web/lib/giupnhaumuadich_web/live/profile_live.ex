defmodule GiupnhaumuadichWeb.ProfileLive do
  use GiupnhaumuadichWeb, :live_view
  alias Surface.Components.Form
  alias Surface.Components.Form.{Submit}

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="my-4 heading-1">Thông tin tài khoản</h1>
    <div class="my-4">
      <div>Họ tên: {@current_user.name}</div>
    </div>
    <Form for={:user} method="delete" action={Routes.user_session_path(@socket, :delete)}>
      <Submit class="border rounded bg-brand-700 text-white py-1 px-4 hover:bg-brand-800">Logout</Submit>
    </Form>
    """
  end
end
