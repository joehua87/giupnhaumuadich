defmodule GiupnhaumuadichWeb.PublicMedicalRecordLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, MedicalRecord}
  alias GiupnhaumuadichWeb.Components.Icon

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> load_data(params)}
  end

  @impl true

  def handle_event(
        "load_entity",
        _,
        socket = %{assigns: %{entity: entity}}
      ) do
    {:reply, ensure_nested_map(%{entity: entity}), socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="my-6 flex items-center justify-center">
    <div class="bg-green-500 w-14 h-14 rounded-full flex items-center justify-center">
    <Icon icon="check" class="w-10 h-10 text-white" />
    </div>
    </div>
    <h1 class="heading-1 text-center px-6">Gửi yêu cầu trợ giúp y tế thành công</h1>
    <div class="max-w-lg mx-auto">
    <p class="rounded bg-yellow-50 p-2">Vui lòng lưu đường dẫn này để theo dõi phản hồi từ bác sĩ</p>
    <div id="medical-record-view" phx-hook="MedicalRecordView" />
    </div>
    """
  end

  defp load_data(socket, %{"id" => id, "token" => token}) do
    entity =
      Repo.one(
        from r in MedicalRecord,
          where: r.id == ^id and r.token == ^token,
          preload: [:category, :doctor],
          limit: 1
      )

    assign(socket, %{entity: entity})
  end
end
