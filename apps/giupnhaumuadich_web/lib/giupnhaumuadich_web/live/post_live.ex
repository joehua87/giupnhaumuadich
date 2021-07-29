defmodule GiupnhaumuadichWeb.PostLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Tiêu đề bài viết</h1>
    """
  end
end
