defmodule GiupnhaumuadichWeb.Components.TextMessage do
  use Surface.Component

  prop value, :string

  def render(assigns) do
    ~F"""
    <div :if={@value} class="overflow-x-hidden">
      {#for line <- String.split(@value, "\n")}
        <p class="mb-1">{line}</p>
      {/for}
    </div>
    """
  end
end
