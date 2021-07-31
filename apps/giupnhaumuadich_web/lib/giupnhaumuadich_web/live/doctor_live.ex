defmodule GiupnhaumuadichWeb.DoctorLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, Doctor}
  alias GiupnhaumuadichWeb.Components.TextMessage

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> load_data(params)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1 class="heading-1">{@doctor.name}</h1>
    <div>{@doctor.phone}</div>
    <TextMessage value={@doctor.intro} />
    <div>
      {#for %{"url" => url} <- @doctor.links}
        <p>
          <a href={url} target="__blank">{url}</a>
        </p>
      {/for}
    </div>
    """
  end

  defp load_data(socket, %{"slug" => slug}) do
    doctor = Repo.one(from d in Doctor, where: d.slug == ^slug, limit: 1)
    assign(socket, %{doctor: doctor, page_title: "Bác sĩ #{doctor.name}"})
  end
end
