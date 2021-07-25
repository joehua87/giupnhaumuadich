defmodule GiupnhaumuadichWeb.Components.ImageSlider do
  use Surface.Component

  prop value, :list
  prop size, :string, default: :medium

  def render(assigns) do
    count = length(assigns.value)

    ~F"""
    {#if count > 0}
      <div class="text-sm text-gray-500">{count} images, scroll to see</div>
      <div class="flex mt-1 overflow-x-scroll">
        {#for src <- @value}
          <div class="flex-none mr-2 mb-2">
            <img
              src={src}
              class={"rounded", "max-h-32": @size == :medium, "max-h-16": @size == :small}
              loading="lazy"
            />
          </div>
        {/for}
      </div>
    {#else}
      <div class="text-sm text-gray-500">No images found</div>
    {/if}
    """
  end
end
