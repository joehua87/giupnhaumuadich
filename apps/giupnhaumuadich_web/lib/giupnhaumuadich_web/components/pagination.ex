defmodule GiupnhaumuadichWeb.Components.Pagination do
  use Surface.Component
  alias Surface.Components.LiveRedirect
  alias GiupnhaumuadichWeb.Components.Icon
  prop path, :string, required: true
  prop query, :any, required: true
  prop paging, :any, required: true

  def render(%{path: path, query: query, paging: paging} = assigns) do
    prev = make_prev_url(path, query, paging)
    next = make_next_url(path, query, paging)

    ~F"""
    <div class="flex justify-between">
      <div class="flex items-center">
        {#if prev}
          <LiveRedirect to={prev}><Icon icon="chevron-left" class="w-8 h-8 bg-white rounded shadow" /></LiveRedirect>
        {#else}
          <span class="cursor-not-allowed text-gray-400"><Icon icon="chevron-left" class="w-8 h-8 rounded" /></span>
        {/if}
        <span class="mx-2"><span class="font-bold">{@paging.page_number}</span> / {@paging.total_pages} ({@paging.total_entities})</span>
        {#if next}
          <LiveRedirect to={next}><Icon icon="chevron-right" class="w-8 h-8 bg-white rounded shadow" /></LiveRedirect>
        {#else}
          <span class="cursor-not-allowed text-gray-400"><Icon icon="chevron-right" class="w-8 h-8 rounded" /></span>
        {/if}
      </div>
      <div>
        <LiveRedirect
          class={"border p-1", "bg-brand-700 text-white": query["limit"] in [nil, "24"]}
          to={make_limit_url(path, query, 24)}
        >
          24
        </LiveRedirect>
        <LiveRedirect
          class={"border p-1", "bg-brand-700 text-white": query["limit"] == "60"}
          to={make_limit_url(path, query, 60)}
        >
          60
        </LiveRedirect>
      </div>
    </div>
    """
  end

  defp make_prev_url(_path, _query, %{page: 1}), do: nil

  defp make_prev_url(path, query, %{page: page} = paging),
    do: make_page_url(path, query, %{paging | page: page - 1})

  defp make_next_url(_path, _query, %{page: page, total_pages: page}), do: nil

  defp make_next_url(path, query, %{page: page} = paging),
    do: make_page_url(path, query, %{paging | page: page + 1})

  defp make_page_url(path, query, %{page: page}) do
    querystring = query |> Map.put("page", page) |> URI.encode_query()
    "#{path}?#{querystring}"
  end

  defp make_limit_url(path, query, limit) do
    querystring = query |> Map.put("limit", limit) |> URI.encode_query()
    "#{path}?#{querystring}"
  end
end
