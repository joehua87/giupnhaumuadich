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
      <div class="flex flex-row border-b-2 w-full pb-1 items-center">
        <div class="rounded-full flex flex-none bg-gray-200 h-10 w-10 items-center justify-center">
          <Icon icon="user" class="h-6 text-gray-600 w-6" />
        </div>
        <div class="ml-2 w-auto">
          <h3 class="font-medium">{@entity.name}</h3>
          <span class="text-sm">{@entity.common_field_values["sex"]} • {@entity.common_field_values["height"]} cm • {@entity.common_field_values["weight"]} kg • ngày sinh: {@entity.birthday}</span>
          <div class="tag-subtle">{@entity.category.name}</div>
          <div class="mt-2 text-sm w-full">Ngày nhận hồ sơ: {Timex.format!(@entity.inserted_at, "{relative}", :relative)}</div>
        </div>

        </div>

        <div class="bg-gray-50 text-sm p-2">
          <div class="label">Mô tả triệu chứng:</div>
          <div class="pb-2">{trieu_chung}</div>
          {#case @entity}
          {#match %{assets: %{"current_symptoms" => images = [_ | _]}}}
            <div class="mt-2 label">Hình ảnh triệu chứng:</div>
            <ImageSlider value={Enum.map(images, &"/upload/#{&1}")} />
          {#match _}
        {/case}
        </div>

        <MedicalRecordAction entity={@entity} doctor={@doctor} transit={@transit} />

        <div class="mb-6 grid gap-x-3 grid-cols-2">
          <a class="rounded bg-blue-500 shadow text-white text-center w-full py-2.5 block" href={"https://zalo.me/#{@entity.phone}"}>
            <div class="text-sm">Tư vấn nhanh</div>
            <div class="font-medium">chat Zalo</div>
          </a>
          <a class="rounded font-medium bg-green-500 shadow text-white text-center w-full py-2.5 block" href={"tel:#{@entity.phone}"}>
            <div class="text-sm">Gọi trực tiếp</div>
            <div class="font-medium">{@entity.phone}</div>
          </a>
        </div>

        <div class="border-t-2 mt-3 pt-2">
          {#if @entity.doctor_id}
            <div>
              <div class="label">Bác sĩ theo dõi:</div>
               {@entity.doctor.name}
              </div>
          {/if}
        </div>
        <div class="flex mt-4 justify-end">
          <LiveRedirect class="flex text-brand-700 items-center items-end justify-end hover:text-brand-800" to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
            <span class="mr-1 text-sm">Xem chi tiết hồ sơ</span>
            <Icon icon="arrow-right" class="h-4 w-4" />
          </LiveRedirect>
          <LiveRedirect class="flex mx-4 text-brand-700 items-center items-end justify-end hover:text-brand-800" to={Routes.public_medical_record_path(@socket, :show, @entity.id, token: @entity.token)}>
            <span class="mr-1 text-sm">Link share cho mọi người</span>
            <Icon icon="arrow-right" class="h-4 w-4" />
          </LiveRedirect>
        </div>
      </div>
    </div>
    """
  end
end
