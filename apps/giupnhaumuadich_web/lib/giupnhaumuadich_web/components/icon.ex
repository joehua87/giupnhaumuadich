defmodule GiupnhaumuadichWeb.Components.Icon do
  use Surface.Component

  prop icon, :string
  prop class, :css_class

  def render(assigns) do
    ~F"""
    <svg
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      class={@class || "h-5 text-accent-500 w-5 icon"}
    >
      <use href={"/assets/sprite-icons.svg##{@icon}"}></use>
    </svg>
    """
  end
end
