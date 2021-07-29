defmodule GiupnhaumuadichWeb.Components.MedicalRecordAction do
  use GiupnhaumuadichWeb, :component

  prop entity, :any
  prop assign_record, :event, required: true

  @impl true
  def render(assigns) do
    %{label: state_label, class: state_class} = state_view(assigns.entity.state)
    actions = get_actions(assigns)

    ~F"""
    <div>
      <div>
        <button class={"font-medium rounded", state_class}>{state_label}</button>
      </div>
      {#for %{label: label, class: class, event: event} <- actions}
        <button
          class={"text-white px-2 rounded", class}
          :on-click={event}
          :values={id: @entity.id}
        >
          {label}
        </button>
      {/for}
    </div>
    """
  end

  defp state_view(:pending), do: %{label: "Đang chờ tư vấn", class: "text-yellow-700"}
  defp state_view(:in_process), do: %{label: "Đang xử lý", class: "text-blue-700"}
  defp state_view(:completed), do: %{label: "Hoàn tất", class: "text-green-700"}

  defp get_actions(%{entity: %{state: :pending}, assign_record: assign_record}) do
    [
      %{label: "Nhận hồ sơ", class: "bg-green-700", event: assign_record}
    ]
  end

  defp get_actions(%{entity: %{state: :in_process}}) do
    []
  end

  defp get_actions(%{entity: %{state: :completed}}), do: []
end
