defmodule GiupnhaumuadichWeb.Components.CategoryCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.Icon

  prop entity, :any

  @impl true
  def render(assigns) do
    ~F"""
    <LiveRedirect
      class="bg-white rounded flex shadow-sm w-full p-2 justify-between hover:shadow-lg"
      to={Routes.category_path(@socket, :show, @entity.slug)}
    >
      <div>
        <div class="heading-3">
          {String.capitalize(@entity.name)}
        </div>
        <div class="text-sm text text-gray-500 line-clamp-3">
          {#for item <- @entity.tags}
            <span class="mr-1 mb-1 tag">{item}</span>
          {/for}
        </div>
        {#if @entity.doctor_count > 0}
          <div>
            <span class="text-sm text-gray-500">{@entity.doctor_count} bác sĩ</span>
          </div>
        {/if}
      </div>
      <div class="flex-none">
        <Icon icon="chevron-right" />
      </div>
    </LiveRedirect>
    """
  end
end
