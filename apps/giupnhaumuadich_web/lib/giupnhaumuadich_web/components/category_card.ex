defmodule GiupnhaumuadichWeb.Components.CategoryCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.Icon

  prop entity, :any

  @impl true
  def render(assigns) do
    ~F"""
    <LiveRedirect
      class="bg-white rounded flex shadow-sm w-full p-2 items-center justify-between hover:shadow-lg"
      to={Routes.category_path(@socket, :show, @entity.slug)}
    >
      <div>
        <div class="heading-3">
          {String.capitalize(@entity.name)}
        </div>
        <div>
          <span class="text-sm text-gray-500">{@entity.doctor_count} bác sĩ</span>
        </div>
      </div>
      <Icon icon="chevron-right" />
    </LiveRedirect>
    """
  end
end
