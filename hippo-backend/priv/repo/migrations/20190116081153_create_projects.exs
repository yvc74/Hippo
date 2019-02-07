defmodule Hippo.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :description, :string, size: 500

      timestamps()
    end
  end
end
