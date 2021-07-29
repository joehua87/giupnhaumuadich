defmodule GiupnhaumuadichWeb.Components.FacebookLogin do
  use GiupnhaumuadichWeb, :component
  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, HiddenInput}

  prop label, :string

  def render(assigns) do
    ~F"""
    <p class="bg-yellow-100 p-2">Hiện này, tính năng đăng nhập với Facebook đang chờ Facebook xét duyệt</p>
    <Form for={:user} class="mt-4" opts={id: "facebook-login"} action={Routes.auth_path(@socket, :facebook)}>
      <Field name="access_token">
        <HiddenInput />
      </Field>
      <button
        style="background: linear-gradient(#4c69ba, #3b55a0)"
        class="rounded flex text-white py-1 px-4 items-center"
        onclick="loginWithFacebook()"
        type="button"
      >
        <svg
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="h-5 text-accent-500 w-5 icon"
          >
          <use href="/assets/sprite-icons.svg#facebook"></use>
        </svg>
        <span class="font-bold ml-2">{@label}</span>
      </button>
    </Form>
    <script async defer src="https://connect.facebook.net/en_US/sdk.js"></script>
    """
  end
end
