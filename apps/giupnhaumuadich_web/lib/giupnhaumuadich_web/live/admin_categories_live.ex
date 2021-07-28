defmodule GiupnhaumuadichWeb.AdminCategoriesLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, Category}
  alias GiupnhaumuadichWeb.Components.{Pagination, Dialog}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(%{
        path: Routes.admin_categories_path(socket, :index)
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket = %{assigns: %{query: query}}) do
    socket = push_patch(socket, to: Routes.admin_categories_path(socket, :edit, id, query))
    {:noreply, socket}
  end

  def handle_event("load_entity", _, socket = %{assigns: %{selected: selected}}) do
    {:reply, ensure_nested_map(%{entity: selected}), socket}
  end

  def handle_event("save_entity", %{"data" => %{"id" => id} = data}, socket) do
    with {:ok, entity} <- get_selected(socket, id) |> Category.changeset(data) |> Repo.update() do
      {:reply, ensure_nested_map(%{entity: entity}), reset_page(socket)}
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply, reset_page(socket)}
  end

  def handle_event("search", %{"keyword" => keyword}, socket = %{assigns: %{query: query}}) do
    socket =
      push_patch(socket,
        to:
          Routes.admin_categories_path(
            socket,
            :index,
            Map.merge(query, %{"keyword" => keyword, "page" => 1})
          )
      )

    {:noreply, socket}
  end

  defp reset_page(socket = %{assigns: %{query: query}}) do
    push_patch(socket, to: Routes.admin_categories_path(socket, :index, query))
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    socket
    |> load_data(params)
    |> assign(%{
      query: Map.delete(params, "id"),
      selected: nil
    })
  end

  defp apply_action(socket, :edit, %{"id" => id} = params) do
    socket = lazy_load_data(socket, params)

    socket
    |> assign(%{
      query: Map.delete(params, "id"),
      selected: get_selected(socket, id)
    })
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Quản lý chuyên khoa</h1>
    <form :on-submit="search">
      <input class="input" type="search" placeholder="Gõ để tìm kiếm" name="keyword" value={@query["keyword"]} />
    </form>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    <table>
      <thead>
        <tr>
          <th style="width: 60px">Index</th>
          <th style="width: 240px">Name</th>
          <th style="width: 480px">Tags</th>
          <th style="width: 480px">Symptoms</th>
          <th style="width: 120px">Actions</th>
        </tr>
      </thead>
      <tbody>
        {#for {entity, index} <- Enum.with_index(@data.entities)}
          <tr>
            <td class="text-right">{index + 1}</td>
            <td>{entity.name}</td>
            <td>{Enum.join(entity.tags, ", ")}</td>
            <td>{Enum.join(entity.symptoms, ", ")}</td>
            <td>
              <button :on-click="edit" :values={id: entity.id}>Edit</button>
              {!-- <button class="text-red-700" :on-click="delete" :values={id: entity.id}>Delete</button> --}
            </td>
          </tr>
        {/for}
      </tbody>
    </table>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>
    {#if @selected}
      <Dialog reset="reset">
        <div id={"edit-category-#{@selected.id}"} phx-hook="CategoryEditForm" phx-update="ignore" />
      </Dialog>
    {/if}
    """
  end

  defp lazy_load_data(%{assigns: %{data: _}} = socket, _params), do: socket
  defp lazy_load_data(socket, params), do: load_data(socket, params)

  defp load_data(socket, params) do
    %{paging: paging, filter: filter} = url_query_to_list_params(params)
    keyword = Map.get(filter, "keyword", "")

    query =
      case String.trim(keyword) do
        "" -> Category
        keyword -> from c in Category, where: fragment("? ilike ?", c.name, ^"%#{keyword}%")
      end

    data = Repo.paginate(from(query, order_by: :name), paging)
    assign(socket, %{data: data})
  end

  defp get_selected(%{assigns: %{data: %{entities: entities}}}, "" <> id) do
    Enum.find(entities, &(&1.id == id))
  end
end
