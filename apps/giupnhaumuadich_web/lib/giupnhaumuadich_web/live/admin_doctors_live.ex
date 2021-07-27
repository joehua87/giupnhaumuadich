defmodule GiupnhaumuadichWeb.AdminDoctorsLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, Doctor}
  alias GiupnhaumuadichWeb.Components.Pagination

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> load_data(params)
      |> assign(:query, params)
      |> assign(:path, Routes.admin_doctors_path(socket, :index))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Quản lý bác sĩ</h1>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    <table>
      <thead>
        <tr>
          <th style="width: 60px">Index</th>
          <th style="width: 240px">Name</th>
          <th style="width: 120px">Phone</th>
        </tr>
      </thead>
      <tbody>
        {#for {entity, index} <- Enum.with_index(@data.entities)}
          <tr>
            <td class="text-right">{index + 1}</td>
            <td>{entity.name}</td>
            <td>{entity.phone}</td>
          </tr>
        {/for}
      </tbody>
    </table>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging} = url_query_to_list_params(params)
    data = Repo.paginate(from(Doctor, order_by: :name), paging)
    assign(socket, %{data: data})
  end
end
