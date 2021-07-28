defmodule GiupnhaumuadichWeb.AdminMedicalRecordLive do
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
    <div class="grid grid-cols-3">
      <div>Họ tên:</div>
      <div class="col-span-2">{@entity.name}</div>
    </div>
    <div>Số điện thoại: {@entity.phone}</div>
    <div>Ngày sinh: {@entity.birthday}</div>
    <div>Chuyên khoa: {@entity.category.name}</div>
    <div>Bác sĩ: {@entity.doctor_id && @entity.doctor.name}</div>
    <div>Tình trạng: {@entity.state}</div>
    <div class="bg-yellow-50">Thông tin bệnh án: Work in progress</div>
    """
  end

  defp load_data(socket, %{"id" => id}) do
    entity =
      Repo.get(
        from(r in MedicalRecord, preload: [:category, :doctor]),
        id
      )

    assign(socket, %{entity: entity})
  end
end
