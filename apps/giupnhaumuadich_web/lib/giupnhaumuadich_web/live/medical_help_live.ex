defmodule GiupnhaumuadichWeb.MedicalHelpLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div>Tro giup y te</div>
    """
  end
end
