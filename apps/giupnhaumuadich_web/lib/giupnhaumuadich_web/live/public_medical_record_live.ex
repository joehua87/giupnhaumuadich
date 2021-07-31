defmodule GiupnhaumuadichWeb.PublicMedicalRecordLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Surface.Components.LiveRedirect
  alias Giupnhaumuadich.{Repo, MedicalRecord}
  alias GiupnhaumuadichWeb.Components.Icon

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> load_data(params)}
  end

  @impl true

  def handle_event(
        "load_entity",
        _,
        socket = %{assigns: %{entity: entity}}
      ) do
    {:reply, ensure_nested_map(%{entity: entity}), socket}
  end

  @impl true
  def render(assigns = %{socket: socket, entity: entity}) do
    path = Routes.public_medical_record_path(socket, :show, entity.id, token: entity.token)
    link = "https://giupnhaumuadich.org#{path}"

    ~F"""
    <div class="flex my-6 items-center justify-center">
      <div class="rounded-full flex bg-green-500 h-14 w-14 items-center justify-center">
        <Icon icon="check" class="h-10 text-white w-10" />
      </div>
      </div>
      <h1 class="text-center px-6 heading-1">Gửi yêu cầu trợ giúp y tế thành công</h1>
      <div class="mx-auto max-w-lg">
        <p class="rounded bg-yellow-50 p-2">Vui lòng lưu đường dẫn này để theo dõi phản hồi từ bác sĩ</p>
        <p class="rounded bg-yellow-50 mt-4 p-2">Hoặc bạn có thể copy đường dẫn sau để gửi bệnh án cho bác sĩ</p>
        {!--<a class="text-blue-700 hover:text-blue-900" href={link}>{link}</a> --}
        <a
          id="copy-to-clipboard"
          class="rounded cursor-pointer flex bg-blue-600 my-4 text-xl text-white text-center w-full py-2 items-center justify-center"
          phx-hook="CopyToClipboard"
          data-link={link}
          phx-update="ignore"
        >
          <Icon icon="copy" />
          <span class="ml-2">Copy đường dẫn</span>
        </a>
        <h2>
          Chuyên khoa:
          <LiveRedirect
            class="font-bold text-brand-700"
            to={Routes.category_path(@socket, :show, @entity.category.slug)}
          >
            {@entity.category.name}
          </LiveRedirect>
        </h2>
        <div id="medical-record-view" phx-hook="MedicalRecordView" />
    </div>
    """
  end

  defp load_data(socket, %{"id" => id, "token" => token}) do
    entity =
      Repo.one(
        from r in MedicalRecord,
          where: r.id == ^id and r.token == ^token,
          preload: [:category, :doctor],
          limit: 1
      )

    assign(socket, %{entity: entity, page_title: "Khám #{entity.category.name} - #{entity.name}"})
  end
end
