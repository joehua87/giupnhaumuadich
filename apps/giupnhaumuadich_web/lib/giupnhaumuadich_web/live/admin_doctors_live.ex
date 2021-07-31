defmodule GiupnhaumuadichWeb.AdminDoctorsLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Surface.Components.LiveRedirect
  alias Giupnhaumuadich.{Repo, Doctor, Category}
  alias Giupnhaumuadich.Accounts.User
  alias GiupnhaumuadichWeb.Components.{Icon, Pagination}

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(%{
        query: Map.delete(params, "id"),
        path: Routes.admin_doctors_path(socket, :index)
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"keyword" => keyword}, socket = %{assigns: %{query: query}}) do
    socket =
      push_patch(socket,
        to:
          Routes.admin_doctors_path(
            socket,
            :index,
            Map.merge(query, %{"keyword" => keyword, "page" => 1})
          )
      )

    {:noreply, socket}
  end

  def handle_event("edit", %{"id" => id}, socket = %{assigns: %{query: query}}) do
    socket = push_patch(socket, to: Routes.admin_doctors_path(socket, :edit, id, query))
    {:noreply, socket}
  end

  def handle_event(
        "load_entity",
        _,
        socket = %{assigns: %{selected: selected, categories: categories, users: users}}
      ) do
    {:reply, ensure_nested_map(%{entity: selected, categories: categories, users: users}), socket}
  end

  def handle_event(
        "save_entity",
        %{"data" => %{"id" => nil, "name" => name, "categories_id" => categories_id} = data},
        socket = %{assigns: %{categories: categories}}
      ) do
    categories = Enum.map(categories_id, fn id -> Enum.find(categories, &(&1.id == id)) end)

    with {:ok, entity} <-
           data
           |> Map.put("slug", Slug.slugify(name))
           |> Doctor.new()
           |> Ecto.Changeset.put_assoc(:categories, categories)
           |> Repo.insert() do
      {
        :reply,
        ensure_nested_map(%{entity: entity}),
        socket |> append_entity(entity) |> reset_page()
      }
    end
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

  defp reset_page(socket = %{assigns: %{query: query}}) do
    push_patch(socket, to: Routes.admin_doctors_path(socket, :index, query))
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

  defp apply_action(socket, :edit, params = %{"id" => id}) do
    socket = lazy_load_data(socket, params)

    assign(socket, %{
      selected: get_selected(socket, id),
      categories: Repo.all(Category),
      users: Repo.all(User)
    })
  end

  defp apply_action(socket, :new, params) do
    socket = lazy_load_data(socket, params)

    assign(socket, %{
      selected: %Doctor{},
      categories: Repo.all(Category),
      users: Repo.all(User)
    })
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Quản lý bác sĩ</h1>
    <form :on-submit="search">
      <input class="input" type="search" placeholder="Gõ để số điện thoại hoặc tên để kiếm" name="keyword" value={@query["keyword"]} />
    </form>
    <div class="my-4">
      <LiveRedirect class="rounded bg-brand-700 text-white py-1 px-4" to={Routes.admin_doctors_path(@socket, :new)}>Thêm bác sĩ</LiveRedirect>
    </div>
    <div class="my-4">
      <Pagination path={@path} query={@query} paging={@data.paging} />
    </div>

    <table>
      <thead>
        <tr>
          <th style="width: 60px">STT</th>
          <th style="width: 240px">Họ tên</th>
          <th style="width: 120px">Phone</th>
          <th style="width: 120px">Link Facebook</th>
          <th style="width: 120px">Tài khoản</th>
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
            {#case entity.user}
              {#match %{name: name, email: email}}
                <span>{name || email}</span>
              {#match _}
            {/case}
            </td>
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

  defp lazy_load_data(%{assigns: %{data: _}} = socket, _params), do: socket
  defp lazy_load_data(socket, params), do: load_data(socket, params)

  defp load_data(socket, params) do
    %{paging: paging, filter: filter} = url_query_to_list_params(params)
    keyword = Map.get(filter, "keyword", "")

    queryable =
      case String.trim(keyword) do
        "" ->
          Doctor

        keyword ->
          from c in Doctor,
            where:
              fragment(
                "? ilike ? or ? ilike ?",
                c.name,
                ^"%#{keyword}%",
                c.phone,
                ^"%#{keyword}%"
              )
      end

    data = Repo.paginate(from(queryable, preload: [:categories, :user], order_by: :name), paging)
    assign(socket, %{data: data, page_title: "Danh sách bác sĩ"})
  end
end
