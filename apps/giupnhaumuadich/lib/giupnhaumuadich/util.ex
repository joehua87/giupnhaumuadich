defmodule Giupnhaumuadich.Util do
  def ensure_slug(%{"slug" => "" <> _} = params), do: params
  def ensure_slug(%{slug: "" <> _} = params), do: params
  def ensure_slug(%{"name" => name} = params), do: Map.put(params, "slug", Slug.slugify(name))
  def ensure_slug(%{name: name} = params), do: Map.put(params, :slug, Slug.slugify(name))

  def ensure_nested_map(%Ecto.Association.NotLoaded{}), do: nil
  def ensure_nested_map(%DateTime{} = v), do: v
  def ensure_nested_map(%Decimal{} = v), do: v
  def ensure_nested_map(v) when is_list(v), do: Enum.map(v, &ensure_nested_map/1)

  def ensure_nested_map(v) when is_struct(v) do
    v |> Map.from_struct() |> Map.drop([:__meta__]) |> ensure_nested_map()
  end

  def ensure_nested_map(v) when is_map(v) do
    for {key, value} <- v, into: %{} do
      {key, ensure_nested_map(value)}
    end
  end

  def ensure_nested_map(v), do: v
end
