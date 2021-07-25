defmodule GiupnhaumuadichWeb.TopicLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Tiêu đề Chủ đề</h1>
    <div>Danh sách bài viết</div>
    """
  end
end
