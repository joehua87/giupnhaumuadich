defmodule GiupnhaumuadichWeb.SignInLive do
  use GiupnhaumuadichWeb, :live_view
  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, TextInput, Label, Submit, HiddenInput}
  # alias Giupnhaumuadich.Accounts
  # alias GiupnhaumuadichWeb.UserAuth

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> assign(:show, false)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="mx-auto max-w-screen-sm my-16">
      {#if @show}
        <div class="bg-white rounded shadow-sm p-4">
          <h1 class="heading-1">Đăng nhập</h1>
          <Form for={:user} action={Routes.user_session_path(@socket, :create)}>
            <Field name="email">
              <Label class="label" />
              <TextInput class="input" />
            </Field>
            <Field name="password" class="field">
              <Label class="label">Mật khẩu</Label>
              <TextInput class="input" />
            </Field>
            <div class="mt-4">
              <Submit class="border rounded bg-brand-700 text-white py-1 px-4 hover:bg-brand-800">
                Đăng nhập
              </Submit>
            </div>
          </Form>
        </div>
      {/if}
      <h1 class="heading-1">Đăng ký / đăng nhập</h1>
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
          <span class="font-bold ml-2">Đăng ký / đăng nhập với Facebook</span>
        </button>
      </Form>
    </div>
    """
  end
end
