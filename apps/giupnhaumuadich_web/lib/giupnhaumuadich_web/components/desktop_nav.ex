defmodule GiupnhaumuadichWeb.Components.DesktopNav do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect

  def render(assigns) do
    ~F"""
    <nav class="bg-white border-b h-16 shadow-sm w-full top-0 right-0 left-0 grid-cols-5 lg:grid hidden">
      {#for %{image: image_src, path: path, label: label} <- nav_items(@socket, assigns[:current_user])}
        <LiveRedirect class="flex flex-col items-center justify-center" to={path}>
          <img src={image_src} class="h-6 w-6" />
          <span class="mt-1 text-xs block">{label}</span>
        </LiveRedirect>
      {/for}
    </nav>
    """
  end
end
