defmodule GiupnhaumuadichWeb.Components.MedicalRecordAction do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect

  prop entity, :any

  @impl true
  def render(assigns) do
    ~F"""
    <div>
      <div>Tình trạng: {@entity.state}</div>
      {#if @entity.doctor_id}
        <div>Bác sĩ theo dõi: {@entity.doctor.name}</div>
      {#else}
        <button>Nhận tư vấn</button>
        <LiveRedirect to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
          Xem chi tiết
        </LiveRedirect>
      {/if}
    </div>
    """
  end
end
