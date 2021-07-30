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
      <div class="flex flex-row items-center w-full border-b-2 pb-1">
        <div class="bg-gray-200 rounded-full w-10 h-10 flex items-center justify-center flex-none">
          <Icon icon="user" class="w-6 h-6 text-gray-600" />
        </div>
        <div class="ml-2 w-auto">
          <h3 class="font-medium">{@entity.name}</h3>
          <span class="text-sm">{@entity.common_field_values["sex"]} • {@entity.common_field_values["height"]} cm • {@entity.common_field_values["weight"]} kg • ngày sinh: {@entity.birthday}</span>
          <div class="tag-subtle">{@entity.category.name}</div>
          <div class="text-sm w-full mt-2">Ngày nhận hồ sơ: {Timex.format!(@entity.inserted_at, "{relative}", :relative)}</div>
        </div>

        </div>

        <div class="p-2 bg-gray-50 text-sm">
          <div class="label">Mô tả triệu chứng:</div>
          <div class="pb-2">{trieu_chung}</div>
          {#case @entity}
          {#match %{assets: %{"current_symptoms" => images = [_ | _]}}}
            <div class="label mt-2">Hình ảnh triệu chứng:</div>
            <ImageSlider value={Enum.map(images, &"/upload/#{&1}")} />
          {#match _}
        {/case}
        </div>

        <MedicalRecordAction entity={@entity} doctor={@doctor} transit={@transit} />

        <div class="grid grid-cols-2 gap-x-3 mb-6">
          <a class="w-full block bg-blue-500 py-2.5 rounded text-white text-center  shadow" href={"https://zalo.me/#{@entity.phone}"}>
            <div class="text-sm">Tư vấn nhanh</div>
            <div class="font-medium">chat Zalo</div>
          </a>
          <a class="w-full block bg-green-500 py-2.5 rounded text-white text-center font-medium shadow" href={"tel:#{@entity.phone}"}>
            <div class="text-sm">Gọi trực tiếp</div>
            <div class="font-medium">{@entity.phone}</div>
          </a>
        </div>

        <div class="mt-3 pt-2 border-t-2">
          {#if @entity.doctor_id}
            <div>
              <div class="label">Bác sĩ theo dõi:</div>
               {@entity.doctor.name}
              </div>
          {/if}
        </div>

        <LiveRedirect class="flex text-brand-700 items-center hover:text-brand-800 mt-4 flex items-end justify-end" to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
        <span class="mr-1 text-sm">Xem chi tiết hồ sơ</span>
        <Icon icon="arrow-right" class="w-4 h-4" />
      </LiveRedirect>
      </div>
    </div>
    """
  end
end
