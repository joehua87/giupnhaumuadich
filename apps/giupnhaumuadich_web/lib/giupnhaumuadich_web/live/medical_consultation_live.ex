defmodule GiupnhaumuadichWeb.MedicalConsultationLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Surface.Components.LiveRedirect
  alias Giupnhaumuadich.{Repo, Category}
  alias GiupnhaumuadichWeb.Components.{Icon}

  @impl true
  def mount(params, _session, socket) do
    {:ok, load_data(socket, params)}
  end

  @impl true
  def handle_event("keyword_changed", %{"keyword" => keyword}, socket) do
    categories = get_matched_categories(socket, keyword)
    {:noreply, assign(socket, :categories, categories)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <form class="my-4" phx-change="keyword_changed"">
    <div class="flex items-center border rounded-md overflow-hidden">
      <Icon icon="search" class="w-6 h-6 mx-2" />
      <input class="text-base w-full px-3 py-2 focus:outline-none focus:border-blue-200 focus:bg-blue-50" name="keyword" placeholder="Tìm kiếm chuyên khoa…" />
      </div>
    </form>
    <h3 class="font-medium text-gray-500 text-sm my-2">Danh sách chuyên khoa</h3>
    <div class="grid divide-y divide-gray-300 grid-cols-1 md:grid-cols-2 xl:grid-cols-4">
      {#for cat <- @categories}
        <LiveRedirect class="flex items-center justify-between w-full py-1.5" to={Routes.category_path(@socket, :show, cat.slug)}>
        <div>
          <div class="heading-3">
            {String.capitalize(cat.name)}
          </div>
          <div>
            <span class="text-sm text-gray-500">{cat.doctor_count} bác sĩ</span>
          </div>
          </div>
          <Icon icon="chevron-right" />
        </LiveRedirect>
      {/for}
    </div>
    """
  end

  defp get_matched_categories(%{assigns: %{all_categories: all_categories}}, keyword) do
    keyword_slug = Slug.slugify(keyword, separator: " ")

    case keyword_slug do
      nil ->
        all_categories

      _ ->
        Enum.filter(all_categories, fn %{name: name} ->
          String.contains?(
            Slug.slugify(name, separator: " "),
            Slug.slugify(keyword, separator: " ")
          )
        end)
    end
  end

  defp load_data(socket, _params) do
    all_categories = Repo.all(from Category, order_by: :name)

    assign(socket, %{
      all_categories: all_categories,
      categories: all_categories
    })
  end
end
