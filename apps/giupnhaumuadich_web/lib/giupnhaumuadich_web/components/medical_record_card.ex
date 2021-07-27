defmodule GiupnhaumuadichWeb.Components.MedicalRecordCard do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.LiveRedirect

  prop entity, :any

  @impl true
  def render(assigns) do
    ~F"""
    <div class="bg-white border rounded shadow-sm p-4">
      <LiveRedirect to={Routes.admin_medical_record_path(@socket, :show, @entity.id)}>
        <h3 class="heading-3">{@entity.name}</h3>
        <div class="font-medium text-sm text-gray-500">
          <div>{@entity.region["address"]}</div>
          <div>{@entity.common_field_values["height"]} cm</div>
          <div>{@entity.common_field_values["weight"]} kg</div>
          <div>{@entity.common_field_values["sex"]}</div>
          <div>{@entity.birthday}</div>
          <a>Facebook</a>
        </div>
      </LiveRedirect>
      <p class="font-medium text-gray-700">{@entity.phone}</p>
    </div>
    """
  end
end
