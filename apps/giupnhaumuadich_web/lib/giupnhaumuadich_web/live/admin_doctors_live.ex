defmodule GiupnhaumuadichWeb.AdminDoctorsLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, Doctor, Category}
  alias GiupnhaumuadichWeb.Components.{Icon, Pagination}

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> load_data(params)
      |> assign(%{
        query: Map.delete(params, "id"),
        path: Routes.admin_doctors_path(socket, :index)
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket = %{assigns: %{query: query}}) do
    socket = push_patch(socket, to: Routes.admin_doctors_path(socket, :edit, id, query))
    {:noreply, socket}
  end

  def handle_event(
        "load_entity",
        _,
        socket = %{assigns: %{selected: selected, categories: categories}}
      ) do
    {:reply, ensure_nested_map(%{entity: selected, categories: categories}), socket}
  end

  def handle_event(
        "save_entity",
        %{"data" => %{"id" => id, "categories_id" => categories_id} = data},
        socket = %{assigns: %{categories: categories}}
      ) do
    categories = Enum.map(categories_id, fn id -> Enum.find(categories, &(&1.id == id)) end)

    with {:ok, entity} <-
           get_selected(socket, id)
           |> Doctor.changeset(data)
           |> Ecto.Changeset.put_assoc(:categories, categories)
           |> Repo.update() do
      {
        :reply,
        ensure_nested_map(%{entity: entity}),
        socket |> replace_entity(entity) |> reset_page()
      }
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply, reset_page(socket)}
  end

  defp replace_entity(socket = %{assigns: %{data: %{entities: entities} = data}}, entity) do
    index = Enum.find_index(entities, &(&1.id == entity.id))
    assign(socket, %{data: %{data | entities: List.replace_at(entities, index, entity)}})
  end

  defp reset_page(socket = %{assigns: %{query: query}}) do
    push_patch(socket, to: Routes.admin_doctors_path(socket, :index, query))
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, %{selected: nil})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    assign(socket, %{
      selected: get_selected(socket, id),
      categories: Repo.all(Category)
    })
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
          <th style="width: 60px">STT</th>
          <th style="width: 240px">Họ tên</th>
          <th style="width: 120px">Phone</th>
          <th style="width: 120px">Facebook UID</th>
          <th style="width: 320px">Chuyên khoa</th>
          <th style="width: 120px">Edit</th>
        </tr>
      </thead>
      <tbody>
        {#for {entity, index} <- Enum.with_index(@data.entities)}
          <tr>
            <td class="text-right">{index + 1}</td>
            <td>{entity.name}</td>
            <td>{entity.phone}</td>
            <td>{entity.facebook_uid}</td>
            <td>
              {#for cat <- entity.categories}
                <span class="mr-1 mb-1 tag">{cat.name}</span>
              {/for}
            </td>
            <td><button :on-click="edit" :values={id: entity.id}>Edit</button></td>
          </tr>
        {/for}
      </tbody>
    </table>
    {#if @selected}
      <div class="bg-black h-screen bg-opacity-25 w-screen top-0 left-0 fixed overflow-y-scroll" :on-capture-click="reset">
        <div class="bg-white rounded mx-auto max-w-screen-sm shadow-lg my-32 p-4 relative">
          <button class="top-2 right-2 absolute" :on-click="reset">
            <Icon icon="x" class="h-6 text-gray-700 w-6" />
          </button>
          <div id={"edit-doctor-#{@selected.id}"} phx-hook="DoctorEditForm" phx-update="ignore" />
        </div>
      </div>
    {/if}
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging} = url_query_to_list_params(params)
    data = Repo.paginate(from(Doctor, preload: :categories, order_by: :name), paging)
    assign(socket, %{data: data})
  end

  defp get_selected(%{assigns: %{data: %{entities: entities}}}, "" <> id) do
    Enum.find(entities, &(&1.id == id))
  end
end
