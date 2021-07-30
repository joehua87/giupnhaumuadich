defmodule GiupnhaumuadichWeb.AdminMedicalRecordLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias GiupnhaumuadichWeb.Components.MedicalRecordAction
  alias Giupnhaumuadich.{Repo, Doctor, MedicalRecord, MedicalRecords}

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

  def handle_event(
        "transit",
        %{"id" => id, "action" => action},
        socket = %{assigns: %{doctor: doctor}}
      ) do
    medical_record = get_selected(socket, id)
    action = String.to_atom(action)

    with {:ok, medical_record} <- MedicalRecords.transit(medical_record, action, doctor) do
      {:noreply, replace_entity(socket, Repo.preload(medical_record, :doctor, force: true))}
    else
      # TODO: Put error flash
      _ -> {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="mt-6" />

    <h1 class="heading-1 max-w-lg mx-auto">{@entity.name}</h1>
    <div class="max-w-lg mx-auto">
    <div id="medical-record-view my-4" phx-hook="MedicalRecordView" />
    <MedicalRecordAction entity={@entity} doctor={@doctor} transit="transit" />
      <div class="grid grid-cols-2 gap-x-3 mb-6">
      <a class="w-full block bg-blue-500 py-2.5 rounded text-white text-center  shadow" href={"https://zalo.me/#{@entity.phone}"}>
        <div class="text-sm">Tư vấn nhanh</div>
        <div class="font-medium">chat Zalo</div>
      </a>
      <a class="w-full block bg-green-500 py-2.5 rounded text-white text-center font-medium shadow" href={"tel:#{@entity.phone}"}>
        <div class="text-sm">Gọi trực tiếp</div>
        <div class="font-medium">{@entity.phone}</div>
      </a>
      </div>
    </div>

    """
  end

  defp load_data(socket = %{assigns: %{current_user: current_user}}, %{"id" => id}) do
    entity =
      Repo.get(
        from(r in MedicalRecord, preload: [:category, :doctor]),
        id
      )

    doctor =
      case current_user do
        %{role: :doctor} -> Repo.one(from Doctor, where: [user_id: ^current_user.id], limit: 1)
        _ -> nil
      end

    assign(socket, %{entity: entity, doctor: doctor})
  end
end
