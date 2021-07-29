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
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Hồ sơ đang cần tư vấn</h1>
    <LiveRedirect class={
        "border border-current text-gray-700 px-2 rounded",
        "bg-blue-700 border-blue-700 !text-white": @query["show"] in [nil, ""]
      }
      to={Routes.admin_medical_records_path(@socket, :index)}
    >
      Xem tất cả
    </LiveRedirect>
    <LiveRedirect class={
        "ml-2 border border-current text-gray-700 px-2 rounded",
        "bg-blue-700 border-blue-700 !text-white": @query["show"] == "my-specialize"
      }
      to={Routes.admin_medical_records_path(@socket, :index, show: "my-specialize")}
    >
      Xem chuyên khoa của bạn
    </LiveRedirect>
    <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
      {#for entity <- @data.entities}
        <MedicalRecordCard entity={entity} />
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
