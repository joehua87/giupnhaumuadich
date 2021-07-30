defmodule Giupnhaumuadich.Doctor do
  use Giupnhaumuadich.Schema
  import Ecto.Changeset

  alias Giupnhaumuadich.Accounts.User
  alias Giupnhaumuadich.Category

  @required_fields [:code, :name, :slug]
  @optional_fields [
    :facebook_uid,
    :user_id,
    :phone,
    :other_phones,
    :image,
    :intro,
    :position,
    :organizations,
    :schedule,
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
    field :facebook_uid, :string
    field :other_phones, {:array, :string}, default: []
    field :image, :string
    field :intro, :string
    field :position, :string
    field :organizations, {:array, :string}, default: []
    field :schedule, {:array, :time}, default: []
    field :schedule_text, :string
    field :field_values, {:array, :map}, default: []
    field :links, {:array, :map}, default: []
    field :meta, :map
    belongs_to :user, User
    many_to_many :categories, Category, join_through: "doctor_categories", on_replace: :delete
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
    params = Giupnhaumuadich.Util.ensure_slug(params)

    %__MODULE__{code: make_code()}
    |> changeset(params)
    |> cast_assoc(:categories, with: &Category.assoc_changeset/2)
  end
end
