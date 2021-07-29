defmodule GiupnhaumuadichWeb.Components.MedicalRecordCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.MedicalRecordAction

  prop entity, :any
  prop assign_record, :event, required: true

  @impl true
  def render(assigns) do
    trieu_chung = assigns.entity.common_field_values["trieu_chung"]

    ~F"""
    <div class="bg-white border rounded shadow-sm p-4">
      <div>
        <LiveRedirect to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
          <h3 class="heading-3">{@entity.name}</h3>
        </LiveRedirect>
        <div class="text-sm text-gray-800">
          <div>{@entity.region["address"]}</div>

          <div className="grid divide-y divide-dotted divide-gray-400">
            <div class="grid grid-cols-3 gap-x-4 py-1.5">
              <div >Giới tính</div>
              <div class="col-span-2">{@entity.common_field_values["sex"]}</div>
            </div>
            <div class="grid grid-cols-3 gap-x-4 py-1.5">
              <div>Chiều cao (cm)</div>
              <div class="col-span-2">{@entity.common_field_values["height"]} cm</div>
            </div>
            <div class="grid grid-cols-3 gap-x-4 py-1.5">
              <div>Cân nặng (kg)</div>
              <div class="col-span-2">{@entity.common_field_values["weight"]} kg</div>
            </div>
            <div class="grid grid-cols-3 gap-x-4 py-1.5">
              <div>Ngày sinh</div>
              <div class="col-span-2">{@entity.birthday}</div>
            </div>
          </div>
          <div>{trieu_chung}</div>
          <p class="font-medium text-gray-700">{@entity.phone}</p>
        </div>
        <MedicalRecordAction entity={@entity} assign_record={@assign_record} />
        {#if @entity.doctor_id}
          <div>Bác sĩ theo dõi: {@entity.doctor.name}</div>
        {/if}
        <LiveRedirect to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
          Xem chi tiết
        </LiveRedirect>
      </div>
    </div>
    """
  end
end
