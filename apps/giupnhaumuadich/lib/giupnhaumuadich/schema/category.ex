defmodule Giupnhaumuadich.Category do
  use Giupnhaumuadich.Schema
  import Ecto.Changeset

  @required_fields [:name, :slug, :tags]
  @optional_fields [:description, :image, :doctor_count]

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :tags, {:array, :string}, default: []
    field :image, :string
    field :doctor_count, :integer
  end

  def changeset(entity, params) do
    entity
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
