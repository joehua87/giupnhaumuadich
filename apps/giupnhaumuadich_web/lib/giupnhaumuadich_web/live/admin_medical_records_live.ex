defmodule GiupnhaumuadichWeb.AdminMedicalRecordsLive do
  use GiupnhaumuadichWeb, :live_view
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
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Bệnh án của bạn</h1>
    <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
      {#for entity <- @data.entities}
        <MedicalRecordCard entity={entity} />
      {/for}
    </div>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging} = url_query_to_list_params(params)
    data = Repo.paginate(MedicalRecord, paging)
    assign(socket, %{data: data})
  end
end
