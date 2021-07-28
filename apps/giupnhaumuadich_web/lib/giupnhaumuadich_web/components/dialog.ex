defmodule GiupnhaumuadichWeb.Components.Dialog do
  use Surface.Component
  alias GiupnhaumuadichWeb.Components.Icon

  prop reset, :event
  slot default, required: true

  def render(assigns) do
    ~F"""
    <div
      class="bg-black h-screen bg-opacity-25 w-screen top-0 left-0 fixed overflow-y-scroll"
      :on-capture-click={@reset}
    >
      <div class="bg-white rounded mx-auto max-w-screen-sm shadow-lg my-32 p-4 relative">
        <button class="top-2 right-2 absolute" :on-click={@reset}>
          <Icon icon="x" class="h-6 text-gray-700 w-6" />
        </button>
        <#slot />
      </div>
    </div>
    """
  end
end
