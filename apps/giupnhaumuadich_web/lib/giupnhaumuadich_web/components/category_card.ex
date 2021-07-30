defmodule GiupnhaumuadichWeb.Components.CategoryCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.Icon

  prop entity, :any

  @impl true
  def render(assigns) do
    ~F"""
    <LiveRedirect
      class="bg-white rounded flex shadow w-full p-4 justify-between hover:shadow-lg"
      to={Routes.category_path(@socket, :show, @entity.slug)}
    >
      <div class="w-full">
      <div class="flex justify-between items-center w-full border-b py-1">
        <div class="heading-3">
          {String.capitalize(@entity.name)}
          {#if @entity.doctor_count > 0}
            <span class="text-sm text-gray-500">{@entity.doctor_count} bác sĩ</span>
        {/if}
        </div>
        <div class="">
          <Icon icon="chevron-right" />
        </div>
      </div>

        <div class="text-sm text text-gray-500 line-clamp-3 mt-3">
          {#for item <- @entity.tags}
            <span class="mr-0.5 mb-1.5 tag-subtle">{item}</span>
          {/for}
        </div>

      </div>

    </LiveRedirect>
    """
  end
end
