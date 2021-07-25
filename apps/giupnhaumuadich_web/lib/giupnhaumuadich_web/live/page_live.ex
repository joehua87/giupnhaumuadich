defmodule GiupnhaumuadichWeb.PageLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Surface.Components.LiveRedirect
  alias Giupnhaumuadich.{Repo, Category}

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
    <form class="my-4" phx-change="keyword_changed">
      <input class="border rounded text-lg w-full px-4" name="keyword" placeholder="Nhập từ khóa để tìm kiếm chuyên khoa..." />
    </form>
    <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-4">
      {#for cat <- @categories}
        <div class="border rounded p-2">
          <LiveRedirect
            class="heading-3"
            to={Routes.category_path(@socket, :show, cat.slug)}
          >
            {String.capitalize(cat.name)}
          </LiveRedirect>
          <p>
            <span class="text-sm text-gray-500">{cat.doctor_count} bác sĩ</span>
          </p>
        </div>
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
