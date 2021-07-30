defmodule GiupnhaumuadichWeb.Components.FilterItem do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.Icon

  prop path, :atom
  prop action, :atom
  prop query, :map
  prop key, :string
  prop items, :list

  def render(assigns) do
    ~F"""
    <div class="flex items-center">
      {#for %{value: value, label: label} <- @items}
        <LiveRedirect
          class={
            "text-gray-700 px-3 py-2 inline-block",
            "border-b-2 border-blue-700 text-blue-700 bg-blue-100 rounded rounded-b-none": @query[@key] == value
          }
          to={apply(Routes, @path, [@socket, @action, Map.put(@query, @key, value)])}
        >
          {label}
        </LiveRedirect>
      {/for}
      <LiveRedirect
        class="py-1 px-3 text-gray-700 inline-flex"
        to={apply(Routes, @path, [@socket, @action, Map.delete(@query, @key)])}
      >
        <Icon icon="x"></Icon>
        <span>Xóa lọc</span>
      </LiveRedirect>
    </div>
    """
  end
end
