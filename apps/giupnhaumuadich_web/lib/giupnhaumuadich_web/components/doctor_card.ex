defmodule GiupnhaumuadichWeb.Components.DoctorCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.{Icon, TextMessage}

  prop entity, :any

  @impl true
  def render(assigns) do
    ~F"""
    <div class="bg-white border rounded shadow-sm block">
      <div class="flex p-4">
        <div class="flex-none">
          <div class="rounded-full bg-gray-400 h-20 w-20" />
          <div class="border-t flex border-gray-100 mt-2 pt-2 text-gray-700">
            <a><Icon icon="facebook" /></a>
            <a class="ml-2"><Icon icon="message-square" /></a>
          </div>
        </div>
        <div class="ml-4">
          <LiveRedirect to={Routes.doctor_path(@socket, :show, @entity.slug)}>
            <h3 class="heading-3">{@entity.name}</h3>
          </LiveRedirect>
          <p class="font-medium text-gray-700 flex items-center"><Icon icon="phone" class="w-4 h-4 mr-1" />{@entity.phone}</p>
          <div class="mt-1">
            {#for cat <- @entity.categories}
              <span class="tag-subtle">{cat.name}</span>
            {/for}
          </div>
          <div class="text-sm text-gray-600">
            <TextMessage value={@entity.schedule_text}></TextMessage>
          </div>
        </div>
      </div>
      <div class="divide-x border-t flex font-medium py-2 text-gray-700 text-sm">
        <a class="flex flex-1 items-center justify-center" href={"https://zalo.me/#{@entity.phone}"}>Zalo</a>
        <div class="flex flex-1 items-center justify-center">Messenger</div>
        <div class="flex flex-1 items-center justify-center">Gọi</div>
      </div>
    </div>
    """
  end
end
