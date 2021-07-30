defmodule GiupnhaumuadichWeb.Components.MedicalRecordAction do
  use GiupnhaumuadichWeb, :component
  alias Giupnhaumuadich.MedicalRecords

  prop entity, :any
  prop doctor, :any
  prop transit, :event, required: true

  @impl true
  def render(assigns) do
    %{label: state_label, class: state_class} = state_view(assigns.entity.state)
    actions = MedicalRecords.get_actions(assigns.entity, assigns.doctor)

    ~F"""
    <div>
      <div>
        <button class={"font-medium rounded", state_class}>{state_label}</button>
      </div>
      {#for action <- actions}
        <button
          class={
            "text-white px-2 rounded",
            "bg-green-500": action == :process,
            "bg-yellow-500": action == :return,
            "bg-blue-500": action == :complete
          }
          :on-click={@transit}
          :values={id: @entity.id, action: action}
        >
          {get_action_label(action)}
        </button>
      {/for}
    </div>
    """
  end

  defp state_view(:pending), do: %{label: "Đang chờ tư vấn", class: "text-yellow-700"}
  defp state_view(:in_process), do: %{label: "Đang xử lý", class: "text-blue-700"}
  defp state_view(:completed), do: %{label: "Hoàn tất", class: "text-green-700"}

  defp get_action_label(:process), do: "Nhận hồ sơ"
  defp get_action_label(:return), do: "Trả về"
  defp get_action_label(:complete), do: "Hoàn tất"
end
