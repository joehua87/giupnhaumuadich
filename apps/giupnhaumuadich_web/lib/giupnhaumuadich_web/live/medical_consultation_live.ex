defmodule GiupnhaumuadichWeb.MedicalConsultationLive do
  use GiupnhaumuadichWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Giupnhaumuadich.{Repo, Category}
  alias GiupnhaumuadichWeb.Components.{Icon, CategoryCard}

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)
     |> load_data(params)}
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
    <div class="border rounded-md flex items-center overflow-hidden">
      <Icon icon="search" class="h-6 mx-2 w-6" />
      <input class="text-base w-full py-2 px-3 focus:outline-none focus:border-blue-200 focus:bg-blue-50" name="keyword" placeholder="Tìm kiếm chuyên khoa…" />
      </div>
    </form>
    <h3 class="font-medium my-2 text-sm text-gray-500">Danh sách chuyên khoa</h3>
    <div class="grid gap-4 grid-cols-1 md:grid-cols-2 xl:grid-cols-4">
      {#for cat <- @categories}
        <CategoryCard entity={cat} />
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
        Enum.filter(all_categories, fn %{name: name, tags: tags} ->
          text = name <> Enum.join(tags, "")

          String.contains?(
            Slug.slugify(text, separator: " "),
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
