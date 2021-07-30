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
            "rounded border text-gray-700 px-2 py-0.5 inline-block not-last:mr-2 bg-white shadow",
            "border-blue-700 text-blue-700 bg-blue-100": @query[@key] == value
          }
          to={apply(Routes, @path, [@socket, @action, Map.put(@query, @key, value)])}
        >
          {label}
        </LiveRedirect>
      {/for}
      <LiveRedirect
        class="rounded py-0.5 px-2 text-gray-700 inline-flex"
        to={apply(Routes, @path, [@socket, @action, Map.delete(@query, @key)])}
      >
        <Icon icon="x"></Icon>
        <span class="ml-1">Bỏ lọc</span>
      </LiveRedirect>
    </div>
    """
  end
end
