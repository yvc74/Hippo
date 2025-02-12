# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hippo.Repo.insert!(%Hippo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Hippo.{
  Lanes.Lane,
  Projects.Project,
  Cards.Card
}

alias Hippo.Repo

require Ecto.Query

defmodule Truncater do
  def truncate(tables) when is_list(tables) do
    tables
    |> Enum.map(&Atom.to_string/1)
    |> Enum.flat_map(&to_queries/1)
    |> Enum.each(&Repo.query/1)
  end

  defp to_queries(table_name) do
    [
      "TRUNCATE TABLE #{table_name} CASCADE",
      "ALTER SEQUENCE #{table_name}_id_seq RESTART WITH 1"
    ]
  end
end

Truncater.truncate([:projects, :lanes, :cards])

# very bare bones helper module to setup some fake projects and data
defmodule ProjectSeeder do
  def project() do
    %Project{
      title: "Project - #{rand_id()}",
      description: "Some Description goes here - #{rand_id()}",
      lanes: Enum.map(0..5, fn _idx -> lane() end)
    }
  end

  def lane() do
    %Lane{
      title: "Lane Title #{rand_id()}",
      description: "A lane description #{rand_id()}",
      cards: Enum.map(0..5, fn _idx -> card() end)
    }
  end

  def card() do
    %Card{
      title: "Card title #{rand_id()}",
      description: "some card description #{rand_id()}"
    }
  end

  defp rand_id() do
    :crypto.strong_rand_bytes(6) |> Base.encode16()
  end
end

# make 25 projects to test with
make_project = fn _idx ->
  ProjectSeeder.project() |> Hippo.Repo.insert()
end

Enum.each(0..25, make_project)
