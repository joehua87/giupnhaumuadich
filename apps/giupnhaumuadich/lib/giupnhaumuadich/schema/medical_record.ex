defmodule Giupnhaumuadich.MedicalRecord do
  use Giupnhaumuadich.Schema
  import Ecto.Changeset

  alias Giupnhaumuadich.{Category, Doctor}

  @required_fields [:name, :phone, :birthday, :region, :category_id]
  @optional_fields [:facebook_uid, :field_values, :images, :state]

  schema "medical_records" do
    field :name, :string
    field :phone, :string
    field :facebook_uid, :string
    field :region, :map
    field :birthday, :date
    field :field_values, :map
    field :assets, {:map, {:array, :string}}
    belongs_to :category, Category
    belongs_to :doctor, Doctor
    field :state, Ecto.Enum, values: [:pending, :in_process, :completed], default: :pending
    field :token, :string
  end

  def changeset(entity, params) do
    entity
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def new(params) do
    changeset(
      %__MODULE__{
        token: Nanoid.generate(32, "0123456789abcdefghijklmnopqrstuvwxyz")
      },
      params
    )
  end
end
