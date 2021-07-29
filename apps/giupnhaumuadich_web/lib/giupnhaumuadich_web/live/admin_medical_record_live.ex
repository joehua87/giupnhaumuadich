defmodule GiupnhaumuadichWeb.AdminMedicalRecordLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, MedicalRecord}

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session)
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
    <h1 class="heading-1">Gửi yêu cầu trợ giúp y tế thành công</h1>
    <p class="rounded bg-yellow-50 p-2">Bạn vui lòng lưu đường dẫn này để theo dõi phải hỏi từ bác sĩ</p>
    <div id="medical-record-view" phx-hook="MedicalRecordView" />
    """
  end

  defp load_data(socket, %{"id" => id}) do
    entity =
      Repo.get(
        from(r in MedicalRecord, preload: [:category, :doctor]),
        id
      )

    assign(socket, %{entity: entity})
  end
end
