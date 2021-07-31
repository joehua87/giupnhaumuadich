defmodule GiupnhaumuadichWeb.AdminMedicalRecordsLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2, dynamic: 2]
  alias Giupnhaumuadich.{Repo, MedicalRecord, Doctor, DoctorCategory, MedicalRecords}
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
  def handle_params(params, _url, socket) do
    socket = socket

    {:noreply, socket}
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
    <div class="my-6">
    {#case @doctor}
    {#match %{name: name}}
      <div>Xin chào, {name}</div>
    {#match _}
    {/case}
      <h1 class="heading-1">Hồ sơ đang chờ tư vấn</h1>

    </div>
    {!--<LiveRedirect class={
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
    </LiveRedirect>--}
    <div class="my-4">
      <p class="label">Lọc theo chuyên khoa của tôi</p>
      <FilterItem
        path={:admin_medical_records_path}
        action={:index}
        query={@query}
        key={"show"}
        items={[%{label: "Tất cả", value: "all"}]}
      />
    </div>
    <div class="my-4">
    <p class="label">Lọc theo trạng thái</p>
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

  defp load_data(socket = %{assigns: %{current_user: current_user}}, params) do
    %{paging: paging, filter: filter} = url_query_to_list_params(params)

    doctor =
      case current_user do
        %{role: :doctor} -> Repo.one(from Doctor, where: [user_id: ^current_user.id], limit: 1)
        _ -> nil
      end

    data = Repo.paginate(queryable(filter, doctor), paging)
    assign(socket, %{data: data, doctor: doctor, page_title: "Bệnh án"})
  end

  defp queryable(filter, nil) do
    condition =
      filter
      |> Enum.into(%{"state" => nil})
      |> Enum.reduce(true, fn item, acc ->
        item_filter =
          case item do
            {"state", "all"} ->
              true

            {"state", state} when state in ["completed", "in_process", "pending"] ->
              dynamic([r], r.state == ^state)

            {"state", _} ->
              dynamic([r], r.state != :completed)

            {"show", _} ->
              true
          end

        dynamic([v], ^acc and ^item_filter)
      end)

    from r in MedicalRecord,
      where: ^condition,
      preload: [:doctor, :category],
      order_by: [desc: :inserted_at]
  end

  defp queryable(filter, %{id: doctor_id}) do
    condition =
      filter
      |> Enum.into(%{"show" => nil, "state" => nil})
      |> Enum.reduce(true, fn item, acc ->
        item_filter =
          case item do
            {"show", "all"} ->
              true

            {"show", _} ->
              dynamic(
                [r],
                r.category_id in subquery(
                  from dc in DoctorCategory,
                    where: [doctor_id: ^doctor_id],
                    select: dc.category_id
                )
              )

            {"state", "all"} ->
              true

            {"state", state} when state in ["completed", "in_process", "pending"] ->
              dynamic([r], r.state == ^state)

            {"state", _} ->
              dynamic([r], r.state != :completed)
          end

        dynamic([v], ^acc and ^item_filter)
      end)

    from r in MedicalRecord,
      where: ^condition,
      preload: [:doctor, :category],
      order_by: [desc: :inserted_at]
  end
end
