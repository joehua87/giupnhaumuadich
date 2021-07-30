defmodule Giupnhaumuadich.Category do
  use Giupnhaumuadich.Schema
  import Ecto.Changeset

  @required_fields [:name, :slug]
  @optional_fields [:description, :tags, :symptoms, :medical_record_fields, :image, :doctor_count]

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :tags, {:array, :string}, default: []
    field :symptoms, {:array, :string}, default: []
    field :medical_record_fields, {:array, :map}, default: []
    field :image, :string
    field :doctor_count, :integer
  end

  def changeset(entity, params) do
    entity
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def assoc_changeset(entity, params) do
    params = Giupnhaumuadich.Util.ensure_slug(params)

    entity
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def new(params) do
    params = Giupnhaumuadich.Util.ensure_slug(params)
    changeset(%__MODULE__{}, params)
  end
end
