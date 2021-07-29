defmodule GiupnhaumuadichWeb.SignUpLive do
  use GiupnhaumuadichWeb, :live_view
  alias Surface.Components.{Form, LiveRedirect}
  alias Surface.Components.Form.{Field, TextInput, Label, Submit, PasswordInput}
  alias GiupnhaumuadichWeb.Components.FacebookLogin

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
      <h1 class="my-4 heading-1">Đăng ký</h1>
      <div class="bg-white rounded shadow-sm p-4">
        <Form for={:user} method="post" action={Routes.user_registration_path(@socket, :create)}>
          <Field class="form-group" name="email">
            <Label class="label" />
            <TextInput class="input" />
          </Field>
          <Field class="form-group" name="name">
            <Label class="label">Họ tên</Label>
            <TextInput class="input" />
          </Field>
          <Field class="form-group" name="password">
            <Label class="label">Mật khẩu</Label>
            <PasswordInput class="input" />
          </Field>
          <div class="mt-4">
            <Submit class="border rounded bg-brand-700 text-white py-1 px-4 hover:bg-brand-800">
              Đăng ký
            </Submit>
          </div>
          <div class="mt-4">
            <LiveRedirect class="text-brand-900" to={Routes.sign_in_path(@socket, :show)}>Đăng nhập</LiveRedirect>
          </div>
        </Form>
      </div>
      <FacebookLogin label="Đăng ký với Facebook" />
    </div>
    """
  end
end
