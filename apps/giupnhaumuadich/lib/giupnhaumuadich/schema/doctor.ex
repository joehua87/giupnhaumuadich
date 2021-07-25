defmodule Giupnhaumuadich.Doctor do
  use Giupnhaumuadich.Schema
  import Ecto.Changeset

  @required_fields [:code, :name, :slug]
  @optional_fields [
    :phone,
    :other_phones,
    :image,
    :intro,
    :position,
    :organizations,
    :schedule_text,
    :field_values,
    :links,
    :meta
  ]

  schema "doctors" do
    field :code, :string
    field :name, :string
    field :slug, :string
    field :phone, :string
    field :other_phones, {:array, :string}, default: []
    field :image, :string
    field :intro, :string
    field :position, :string
    field :organizations, {:array, :string}, default: []
    field :schedule_text, :string
    field :field_values, {:array, :map}, default: []
    field :links, {:array, :map}, default: []
    field :meta, :map
    many_to_many :categories, Giupnhaumuadich.Category, join_through: "doctor_categories"
  end

  def changeset(entity, params) do
    entity
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def make_code() do
    Nanoid.generate(8, "0123456789abcdefghijklmnopqrstuvwxyz")
  end

  def new(params) do
    changeset(%__MODULE__{code: make_code()}, params)
  end
end
