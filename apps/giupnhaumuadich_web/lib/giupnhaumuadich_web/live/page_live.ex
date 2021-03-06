defmodule GiupnhaumuadichWeb.PageLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="my-4">
      {#for %{path: path, image: image_src, label: label, description: description} <- items(@socket)}
        <a href={path} class="bg-white rounded-md flex shadow my-3 w-full py-3 px-3 items-center">
          <img src={image_src} class="h-10 mr-2 w-10" />
          <div class="">
            <span class="font-medium block">{label}</span>
            <span class="text-sm text-gray-600 block">{description}</span>
          </div>
        </a>
      {/for}
    </div>
    <div class="my-4">
      <a href="/tro-giup-y-te" class="rounded-md flex bg-red-600 text-white w-full py-2 items-center uppercase justify-center">
        <img src="/images/ambulance.svg" class="h-10 mr-2 w-10" />
        <span class="font-medium block">Cấp cứu</span>
      </a>
    </div>
    """
  end

  defp items(socket) do
    [
      %{
        image: Routes.static_path(socket, "/images/doctor.svg"),
        path: Routes.medical_consultation_path(socket, :show),
        label: "Tư vấn y tế",
        description: "Tư vấn bệnh, sức khỏe, tâm lý, thuốc"
      },
      %{
        image: Routes.static_path(socket, "/images/virus.svg"),
        path: Routes.category_path(socket, :show, "covid"),
        label: "Trợ giúp bệnh nhân Covid",
        description: "Cách điều trị, theo dõi tại nhà…"
      },
      %{
        image: Routes.static_path(socket, "/images/helping-hand.svg"),
        path: Routes.page_path(socket, :index),
        label: "Trợ giúp",
        description: "Cho/nhận thực phẩm, vật tư y tế, thuốc…"
      },
      %{
        image: Routes.static_path(socket, "/images/medicine.svg"),
        path: Routes.page_path(socket, :index),
        label: "Trợ giúp vật tư y tế",
        description: "Thuốc men, thiết bị chuyên dụng,…"
      },
      %{
        image: Routes.static_path(socket, "/images/medical.svg"),
        path: Routes.page_path(socket, :index),
        label: "Tra cứu điện thoại",
        description: "CDC, trạm y tế TP.HCM, dịch vụ khác…"
      }
    ]
  end
end
