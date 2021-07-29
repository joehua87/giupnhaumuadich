defmodule GiupnhaumuadichWeb.SignInLive do
  use GiupnhaumuadichWeb, :live_view
  alias Surface.Components.{Form, LiveRedirect}
  alias Surface.Components.Form.{Field, TextInput, Label, Submit, PasswordInput}
  alias GiupnhaumuadichWeb.Components.FacebookLogin

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> assign(:show, true)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="mx-auto max-w-screen-sm my-16">
    <h1 class="my-4 heading-1">Đăng nhập</h1>
      <div class="bg-white rounded shadow-sm p-4">
        <Form for={:user} method="post" action={Routes.user_session_path(@socket, :create)}>
          <Field class="form-group" name="email">
            <Label class="label" />
            <TextInput class="input" />
          </Field>
          <Field class="form-group" name="password">
            <Label class="label">Mật khẩu</Label>
            <PasswordInput class="input" />
          </Field>
          <div class="mt-4">
            <Submit class="border rounded bg-brand-700 text-white py-1 px-4 hover:bg-brand-800">
              Đăng nhập
            </Submit>
          </div>
          <div class="mt-4">
            <LiveRedirect class="text-brand-900" to={Routes.sign_up_path(@socket, :show)}>Đăng ký</LiveRedirect>
          </div>
        </Form>
      </div>
      <FacebookLogin label="Đăng nhập với Facebook" />
    </div>
    """
  end
end
