defmodule GiupnhaumuadichWeb.LiveHelpers do
  alias GiupnhaumuadichWeb.Router.Helpers, as: Routes

  def format_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  def url_query_to_list_params(params) do
    limit = Map.get(params, "limit", 24)
    page = Map.get(params, "page", 1)
    order = Map.get(params, "order")
    filter = Map.drop(params, ["limit", "page"])
    %{filter: filter, paging: %{page: page, page_size: limit}, order: order}
  end

  def list_params_to_url_query(%{filter: filter, paging: %{page: page, page_size: page_size}}) do
    Map.merge(filter, %{"page" => page, "limit" => page_size})
    |> Enum.filter(&(elem(&1, 1) not in [nil, ""]))
    |> URI.encode_query()
  end

  def assets_path(conn, key) do
    if is_prod() do
      Routes.static_path(conn, "/assets/#{key}")
    else
      key = String.replace(key, ~r/\.js$/, ".ts")
      "http://localhost:3000/assets/#{key}"
    end
  end

  def is_prod do
    System.get_env("MIX_ENV") == "prod"
  end
end
