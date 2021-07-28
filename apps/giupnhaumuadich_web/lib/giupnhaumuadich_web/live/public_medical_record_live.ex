defmodule GiupnhaumuadichWeb.PublicMedicalRecordLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, MedicalRecord}

  @impl true
  def mount(params, _session, socket) do
    {:ok, load_data(socket, params)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">Gửi yêu cầu trợ giúp y tế thành công</h1>
    <p class="rounded bg-yellow-50 p-2">Bạn vui lòng lưu đường dẫn này để theo dõi phải hỏi từ bác sĩ</p>
    <span class="bg-gray-700 px-2 py-1 rounded-sm text-xs text-white uppercase font-medium tracking-wide">{@entity.state}</span>
    <div class="my-2 border shadow-md rounded-md overflow-hidden">
    <div class="grid grid-cols-3 border-b border-gray-300 px-2 py-1.5 bg-white">
      <div>Họ tên:</div>
      <div class="col-span-2">{@entity.name}</div>
    </div>
    <div class="grid grid-cols-3 border-b border-gray-300 px-2 py-1.5 bg-white">
      <div>Điện thoại: </div>
      <div class="col-span-2">{@entity.phone}</div>
    </div>
    <div class="grid grid-cols-3 border-b border-gray-300 px-2 py-1.5 bg-white">
      <div>Ngày sinh: </div>
      <div class="col-span-2">{@entity.birthday}</div>
    </div>
    <div class="grid grid-cols-3 border-b border-gray-300 px-2 py-1.5 bg-white">
      <div>Chuyên khoa: </div>
      <div class="col-span-2">{@entity.category.name}</div>
    </div>
    <div class="grid grid-cols-3 border-b border-gray-300 px-2 py-1.5 bg-white">
      <div>Bác sĩ: </div>
      <div class="col-span-2">{@entity.doctor_id && @entity.doctor.name}</div>
    </div>
    </div>


    <div class="bg-yellow-50">Thông tin bệnh án: Work in progress</div>


    """
  end

  defp load_data(socket, %{"id" => id, "token" => token}) do
    entity =
      Repo.one(
        from r in MedicalRecord,
          where: r.id == ^id and r.token == ^token,
          preload: [:category, :doctor],
          limit: 1
      )

    assign(socket, %{entity: entity})
  end
end
