defmodule GiupnhaumuadichWeb.HotlineLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> load_data(params)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Hotline</h1>
    """
  end

  defp load_data(socket, _params) do
    socket
  end
end
