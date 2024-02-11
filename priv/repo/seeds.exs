# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RinhaBackend.Repo.insert!(%RinhaBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule RinhaBackend.DatabaseSeeder do
  alias RinhaBackend.Repo
  alias RinhaBackend.Client

  def insert_client(limit) do
    Repo.insert!(%Client{
      limit: limit,
      amount: 0
    })
  end
end

limits = [100_000, 80000, 1_000_000, 10_000_000, 500_000]
limits |> Enum.each(fn limit -> RinhaBackend.DatabaseSeeder.insert_client(limit) end)
