defmodule GiupnhaumuadichWeb.Components.MedicalRecordCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.{MedicalRecordAction, ImageSlider, Icon}

  prop entity, :any
  prop doctor, :any
  prop transit, :event, required: true

  @impl true
  def render(assigns) do
    trieu_chung = assigns.entity.common_field_values["trieu_chung"]

    ~F"""
    <div class="bg-white border rounded shadow-sm p-4">
      <div>
      <div class="flex items-center w-full border-b-2 pb-1">
        <div class="bg-gray-200 rounded-full w-10 h-10 flex items-center justify-center flex-none">
        <Icon icon="user" class="w-6 h-6 text-gray-600" />
        </div>
        <div class="ml-2 w-auto">

          <h3 class="font-medium">{@entity.name}</h3>
          <span class="text-sm">{@entity.common_field_values["sex"]} • {@entity.common_field_values["height"]} cm • {@entity.common_field_values["weight"]} kg • ngày sinh: {@entity.birthday}</span>
          <div class="tag-subtle">{@entity.category.name}</div>
          </div>
        </div>
        <div class="py-1">
        <div class="label">Triệu chứng:</div>
        <div>{trieu_chung}</div>
        </div>

        <div class="text-sm text-gray-800">
          <div>{@entity.region["address"]}</div>

          <p class="font-medium text-gray-700">{@entity.phone}</p>
        </div>
        <div class="border-t pb-2">
        <MedicalRecordAction entity={@entity} doctor={@doctor} transit={@transit} />
        </div>
        {#if @entity.doctor_id}
          <div>Bác sĩ theo dõi: {@entity.doctor.name}</div>
        {/if}
        {#case @entity}
          {#match %{assets: %{"current_symptoms" => images = [_ | _]}}}
            <ImageSlider value={Enum.map(images, &"/upload/#{&1}")} />
          {#match _}
        {/case}
        <LiveRedirect class="flex text-brand-700 items-center hover:text-brand-800 mt-4 flex items-end justify-end" to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
        <span class="mr-1 text-sm">Xem chi tiết</span>
        <Icon icon="arrow-right" class="w-4 h-4" />
      </LiveRedirect>
      </div>
    </div>
    """
  end
end
