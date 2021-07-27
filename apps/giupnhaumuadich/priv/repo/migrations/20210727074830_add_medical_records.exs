defmodule Giupnhaumuadich.Repo.Migrations.AddMedicalRecords do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :tags, {:array, :string}, default: []
      add :medical_record_fields, :map, default: "[]"
    end

    create table(:medical_records) do
      add :name, :string
      add :phone, :string
      add :facebook_uid, :string
      add :region, :map, null: false
      add :birthday, :date, null: false
      add :field_values, :map
      add :assets, :map
      add :category_id, references(:categories), null: false
      add :doctor_id, references(:doctors)
      add :state, :string, null: false, state: "pending"
      add :token, :text
    end
  end
end
