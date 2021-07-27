defmodule GiupnhaumuadichWeb.AdminCategoriesLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, Category}
  alias GiupnhaumuadichWeb.Components.Pagination

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> load_data(params)
      |> assign(:query, params)
      |> assign(:path, Routes.admin_categories_path(socket, :index))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Quản lý chuyên khoa</h1>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    <table>
      <thead>
        <tr>
          <th style="width: 60px">Index</th>
          <th style="width: 240px">Name</th>
        </tr>
      </thead>
      <tbody>
        {#for {entity, index} <- Enum.with_index(@data.entities)}
          <tr>
            <td class="text-right">{index + 1}</td>
            <td>{entity.name}</td>
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
    data = Repo.paginate(from(Category, order_by: :name), paging)
    assign(socket, %{data: data})
  end
end
