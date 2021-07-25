defmodule Giupnhaumuadich.Repo.Migrations.Initialize do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :image, :string
      add :description, :text
      add :doctor_count, :integer
      add :state, :string
    end

    create table(:doctors) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :slug, :string, null: false
      add :phone, :string, null: false
      add :other_phones, {:array, :string}, null: false, default: []
      add :position, :string
      add :organizations, {:array, :string}, default: []
      add :intro, :text
      add :schedule_text, :text
      add :image, :map
      add :field_values, :map
      add :links, :map
      add :meta, :map
    end

    create index(:doctors, [:code])
    create unique_index(:doctors, [:phone])

    create table(:doctor_categories, primary_key: false) do
      add :doctor_id,
          references(:doctors, on_delete: :delete_all),
          null: false,
          primary_key: true

      add :category_id,
          references(:categories, on_delete: :delete_all),
          null: false,
          primary_key: true
    end

    create table(:subscriptions, primary_key: false) do
      add :name, :string, null: false
      add :phone, :string, null: false
      add :doctor_id, references(:doctors), null: false
      add :field_values, :map

      timestamps()
    end
  end
end
