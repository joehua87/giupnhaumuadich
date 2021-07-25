defmodule GiupnhaumuadichWeb.CategoryLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias GiupnhaumuadichWeb.Components.DoctorCard
  alias Giupnhaumuadich.{Repo, Category, Doctor, DoctorCategory}

  @impl true
  def mount(params, _session, socket) do
    {:ok, load_data(socket, params)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div>
      <div class="container max-w-screen-md">
        <h1 class="my-6 heading-1">{String.capitalize(@category.name)}</h1>
        <div class="rounded bg-yellow-50 my-4 p-4">
          <p>Nếu tình trạng bệnh của bạn chưa thực sự cấp thiết, mình nên điền thông tin đầy đủ rõ ràng ở form bên dưới để bác sĩ dễ dàng chẩn đoán</p>
        </div>
        <div id="diagnosis-form" phx-hook="DiagnosisForm" />
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
