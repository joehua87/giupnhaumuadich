defmodule GiupnhaumuadichWeb.Components.DesktopNav do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect

  def render(assigns) do
    ~F"""
    <div class="bg-white border-b h-16 shadow-sm w-full lg:flex hidden container items-center justify-between">
      <LiveRedirect to={Routes.page_path(@socket, :index)} class="uppercase font-bold text-brand-700">
        Giúp nhau mùa dịch
      </LiveRedirect>
      <nav class="flex items-center">
        {#for %{image: image_src, path: path, label: label} <- nav_items(@socket, assigns[:current_user])}
          <LiveRedirect class="flex items-center ml-6 text-gray-700 font-medium" to={path}>
            <img src={image_src} class="h-5 w-5" />
            <span class="ml-1 block">{label}</span>
          </LiveRedirect>
        {/for}
      </nav>
    </div>
    """
  end
end
