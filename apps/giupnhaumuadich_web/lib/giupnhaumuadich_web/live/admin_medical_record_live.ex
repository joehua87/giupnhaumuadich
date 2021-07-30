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
    <h1 class="my-4 heading-1">{@entity.name}</h1>
    <div id="medical-record-view my-4" phx-hook="MedicalRecordView" />
    <MedicalRecordAction entity={@entity} doctor={@doctor} transit="transit" />
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
