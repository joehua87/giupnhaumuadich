defmodule Giupnhaumuadich.Repo.Migrations.EnhanceUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :avatar, :string
      add :provider, :string
      add :bio, :text
    end
  end
end
