defmodule GiupnhaumuadichWeb.DoctorsLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias GiupnhaumuadichWeb.Components.{DoctorCard, Pagination}
  alias Giupnhaumuadich.{Repo, Doctor}

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(session, false)
      |> load_data(params)
      |> assign(:query, params)
      |> assign(:path, Routes.doctors_path(socket, :index))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="my-6 heading-1">Tất cả bác sĩ</h1>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
      {#for doctor <- @data.entities}
        <div>
          <DoctorCard entity={doctor} />
        </div>
      {/for}
    </div>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging} = url_query_to_list_params(params)
    data = Repo.paginate(from(d in Doctor, preload: [:categories]), paging)
    assign(socket, %{data: data})
  end
end
