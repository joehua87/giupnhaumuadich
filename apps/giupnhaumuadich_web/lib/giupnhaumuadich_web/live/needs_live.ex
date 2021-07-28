defmodule GiupnhaumuadichWeb.NeedsLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Danh sách cần nhận</h1>
    """
  end
end
