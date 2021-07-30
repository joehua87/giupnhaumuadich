defmodule GiupnhaumuadichWeb.CategoryLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias GiupnhaumuadichWeb.Components.DoctorCard
  alias Giupnhaumuadich.{Repo, Category, Doctor, DoctorCategory, MedicalRecords}

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> load_data(params)}
  end

  @impl true

  def handle_event(
        "load_entity",
        _,
        socket = %{assigns: %{category: category}}
      ) do
    {:reply, ensure_nested_map(%{entity: category}), socket}
  end

  def handle_event("submit", params, socket = %{assigns: %{category: %{id: category_id}}}) do
    with {:ok, %{id: id, token: token}} <-
           params
           |> Map.put("category_id", category_id)
           |> MedicalRecords.create() do
      socket =
        socket
        |> push_redirect(to: Routes.public_medical_record_path(socket, :show, id, token: token))

      {:noreply, socket}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Error happens")}
    end
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div>
      <div class="max-w-screen-lg">
        <h1 class="my-6 heading-1">{String.capitalize(@category.name)}</h1>
        <div class="border rounded bg-yellow-50 border-yellow-200 my-4 p-3 text-yellow-700">
          <p>Vui lòng điền thông tin càng chi tiết càng tốt để giúp tiết kiệm thời gian chẩn đoán cho bác sỹ.</p>
        </div>
        <div id="medical-record-form" phx-hook="MedicalRecordForm" />
      </div>
      <div class="border-b my-8" />
      <div>
        <h2 class="heading-2">Danh sách bác sĩ hỗ trợ</h2>
        <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
          {#for doctor <- @doctors}
            <div>
              <DoctorCard entity={doctor} />
            </div>
          {/for}
        </div>
      </div>
    </div>
    """
  end

  defp load_data(socket, %{"slug" => slug}) do
    category = Repo.one(from c in Category, where: c.slug == ^slug, limit: 1)

    doctors =
      Repo.all(
        from d in Doctor,
          where:
            d.id in subquery(
              from dc in DoctorCategory, where: [category_id: ^category.id], select: dc.doctor_id
            ),
          preload: [:categories]
      )

    assign(socket, %{category: category, doctors: doctors})
  end
end
