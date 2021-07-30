defmodule Giupnhaumuadich.Doctors do
  alias Giupnhaumuadich.{Repo, Doctor}

  def create(params) do
    params
    |> Doctor.new()
    |> Repo.insert()
  end

  def ensure_slug(%{"name" => name} = params) do
    Map.put(params, "slug", Slug.slugify(name))
  end

  def ensure_slug(%{name: name} = params) do
    Map.put(params, :slug, Slug.slugify(name))
  end
end
