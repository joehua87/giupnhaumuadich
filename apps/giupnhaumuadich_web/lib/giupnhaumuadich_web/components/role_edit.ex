defmodule GiupnhaumuadichWeb.Components.RoleEdit do
  use Surface.Component

  prop user_id, :string
  prop value, :atom
  prop change, :event

  def render(assigns) do
    roles = [:standard, :doctor, :moderator, :admin]

    ~F"""
    <div>
      {#for role <- roles}
        <button
          :on-click={@change}
          :values={user_id: @user_id, role: role}
          class={
            "px-1 border border-current rounded text-sm text-gray-600 focus:outline-none",
            "text-brand-500 hover:text-brand-600": role == @value
          }
        >
          {role |> to_string() |> String.capitalize()}
        </button>
      {/for}
    </div>
    """
  end
end
