defmodule Giupnhaumuadich.Repo.Migrations.EditDoctor do
  use Ecto.Migration

  def change do
    alter table(:doctors) do
      add :facebook_uid, :string
      add :schedule, :map
      add :user_id, references(:users)
    end
  end
end
