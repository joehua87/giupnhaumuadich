defmodule GiupnhaumuadichWeb.AdminMedicalRecordsLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Surface.Components.LiveRedirect
  alias Giupnhaumuadich.{Repo, MedicalRecord, Doctor, MedicalRecords}
  alias GiupnhaumuadichWeb.Components.{MedicalRecordCard, FilterItem}

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> load_data(params)
      |> assign(:query, params)
      |> assign(:path, Routes.admin_medical_records_path(socket, :index))

    {:ok, socket}
  end

  @impl true
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
    <h1 class="my-6 heading-1">Hồ sơ đang chờ tư vấn</h1>
    <div>Bạn là: {@doctor.name}</div>
    <LiveRedirect class={
        "border-b text-gray-700 px-3 py-2 inline-block",
        "border-b-2 border-blue-700 text-blue-700 bg-blue-100 rounded rounded-b-none": @query["show"] in [nil, ""]
      }
      to={Routes.admin_medical_records_path(@socket, :index)}
    >
      Chỉ chuyên khoa của bạn
    </LiveRedirect>
    <LiveRedirect class={
        "border-b text-gray-700 px-3 py-2 inline-block",
        "border-b-2 border-blue-700 text-blue-700 bg-blue-100 rounded rounded-b-none": @query["show"] == "all"
      }
      to={Routes.admin_medical_records_path(@socket, :index, show: "all")}
    >
      Xem tất cả
    </LiveRedirect>
    <div class="my-4">
      <p>Lọc theo chuyên khóa</p>
      <FilterItem
        path={:admin_medical_records_path}
        action={:index}
        query={@query}
        key={"show"}
        items={[%{label: "Tất cả", value: "all"}]}
      />
    </div>
    <div class="my-4">
      <p>Lọc theo trạng thái</p>
      <FilterItem
        path={:admin_medical_records_path}
        action={:index}
        query={@query}
        key={"state"}
        items={[%{label: "Tất cả", value: "all"}, %{label: "Đang xử lý", value: "in_process"}]}
      />
    </div>
    <div class="mt-4 grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
      {#for entity <- @data.entities}
        <MedicalRecordCard entity={entity} doctor={@doctor} transit="transit" />
      {/for}
    </div>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging, filter: filter} = url_query_to_list_params(params)
    data = Repo.paginate(queryable(filter), paging)
    doctor = Repo.one(from Doctor, limit: 1)
    assign(socket, %{data: data, doctor: doctor})
  end

  defp queryable(%{"show" => "all"}) do
    from r in MedicalRecord, where: r.state == :completed, preload: [:doctor]
  end

  defp queryable(_) do
    from r in MedicalRecord, where: r.state == :completed, preload: [:doctor]
  end
end
