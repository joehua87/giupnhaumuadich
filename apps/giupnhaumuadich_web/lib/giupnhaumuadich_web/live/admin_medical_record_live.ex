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

    <h1 class="mx-auto max-w-lg heading-1">{@entity.name}</h1>
    <div class="mx-auto max-w-lg">
    <div id="medical-record-view my-4" phx-hook="MedicalRecordView" />
    <MedicalRecordAction entity={@entity} doctor={@doctor} transit="transit" />
      <div class="mb-6 grid gap-x-3 grid-cols-2">
      <a class="rounded bg-blue-500 shadow text-white text-center w-full py-2.5 block" href={"https://zalo.me/#{@entity.phone}"}>
        <div class="text-sm">Tư vấn nhanh</div>
        <div class="font-medium">chat Zalo</div>
      </a>
      <a class="rounded font-medium bg-green-500 shadow text-white text-center w-full py-2.5 block" href={"tel:#{@entity.phone}"}>
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

    assign(socket, %{
      entity: entity,
      doctor: doctor,
      page_title: "Khám #{entity.category.name} - #{entity.name}"
    })
  end
end
