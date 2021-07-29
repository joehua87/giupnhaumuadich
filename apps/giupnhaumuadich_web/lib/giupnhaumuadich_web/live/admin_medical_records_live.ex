defmodule GiupnhaumuadichWeb.AdminMedicalRecordsLive do
  use GiupnhaumuadichWeb, :live_view
  alias Surface.Components.LiveRedirect
  alias Giupnhaumuadich.{Repo, MedicalRecord}
  alias GiupnhaumuadichWeb.Components.MedicalRecordCard

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
  def handle_event("assign_record", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1 my-6">Hồ sơ đang cần chờ vấn</h1>
    <LiveRedirect class={
        "border-b text-gray-700 px-2 py-2 inline-block",
        "border-b-2 border-blue-700 text-blue-700 bg-blue-100": @query["show"] in [nil, ""]
      }
      to={Routes.admin_medical_records_path(@socket, :index)}
    >
      Xem tất cả
    </LiveRedirect>
    <LiveRedirect class={
        "border-b text-gray-700 px-2 py-2 inline-block",
        "border-b-2 border-blue-700 text-blue-700 bg-blue-100": @query["show"] == "my-specialize"
      }
      to={Routes.admin_medical_records_path(@socket, :index, show: "my-specialize")}
    >
      Chỉ chuyên khoa của bạn
    </LiveRedirect>
    <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-3 mt-4">
      {#for entity <- @data.entities}
        <MedicalRecordCard entity={entity} assign_record="assign_record" />
      {/for}
    </div>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging, filter: filter} = url_query_to_list_params(params)
    data = Repo.paginate(queryable(filter), paging)
    assign(socket, %{data: data})
  end

  defp queryable(%{"show" => "my-specialize"}) do
    MedicalRecord
  end

  defp queryable(_), do: MedicalRecord
end
