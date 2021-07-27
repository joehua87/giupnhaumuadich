defmodule GiupnhaumuadichWeb.AdminUsersLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.Repo
  alias Giupnhaumuadich.Accounts.User
  alias GiupnhaumuadichWeb.Components.RoleEdit

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> load_data(params)
      |> assign(:query, params)
      |> assign(:path, Routes.admin_medical_records_path(socket, :index))

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "set_role",
        %{"role" => role, "user_id" => user_id} = params,
        socket = %{assigns: %{data: data = %{entities: entities}}}
      ) do
    with {:ok, user} <-
           Repo.get(User, user_id)
           |> User.role_changeset(role)
           |> Repo.update() do
      index = Enum.find_index(entities, &(&1.id == user_id))
      entities = List.replace_at(entities, index, user)
      {:noreply, assign(socket, %{data: %{data | entities: entities}})}
    else
      _ ->
        {:noreply, put_flash(socket, :error, "Update role fail")}
    end
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Quản lý người dùng</h1>
    <table>
      <thead>
        <tr>
          <th style="width: 80px">Index</th>
          <th style="width: 120px">Email</th>
          <th style="width: 300px">Role</th>
          <th style="width: 300px">Inserted at</th>
        </tr>
      </thead>
      <tbody>
        {#for {entity, index} <- Enum.with_index(@data.entities)}
          <tr>
            <td>{index}</td>
            <td>{entity.email}</td>
            <td><RoleEdit value={entity.role} user_id={entity.id} change="set_role" /></td>
            <td>{Timex.format!(entity.inserted_at, "{relative}", :relative)}</td>
          </tr>
        {/for}
      </tbody>
    </table>
    """
  end

  defp load_data(socket, params) do
    %{paging: paging} = url_query_to_list_params(params)
    data = Repo.paginate(from(User, order_by: :inserted_at), paging)
    assign(socket, %{data: data})
  end
end