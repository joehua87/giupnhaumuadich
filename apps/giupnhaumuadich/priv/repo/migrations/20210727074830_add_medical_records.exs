defmodule Giupnhaumuadich.Repo.Migrations.AddMedicalRecords do
  use Ecto.Migration

  def change do
    create table(:medical_records) do
      add :phone, :string
      add :facebook_uid, :string
      add :address, :string, null: false
      add :region_code, :string, null: false
      add :region, :string, null: false
      add :field_values, :map
      add :images, {:array, :string}
      add :category_id, references(:categories), null: false
      add :doctor_id, references(:doctors)
      add :state, :string, null: false, state: "pending"
      add :token, :text
    end
  end
end
