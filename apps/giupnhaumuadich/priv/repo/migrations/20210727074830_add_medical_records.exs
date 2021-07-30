defmodule Giupnhaumuadich.Repo.Migrations.AddMedicalRecords do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :tags, {:array, :text}, default: []
      add :symptoms, {:array, :text}, default: []
      add :medical_record_fields, :map, default: "[]"
    end

    create table(:medical_records) do
      add :name, :string
      add :phone, :string
      add :facebook_uid, :string
      add :region, :map, null: false
      add :birthday, :date
      add :common_field_values, :map
      add :specialize_field_values, :map
      add :assets, :map
      add :category_id, references(:categories), null: false
      add :doctor_id, references(:doctors)
      add :state, :string, null: false, state: "pending"
      add :token, :text

      timestamps()
    end
  end
end
