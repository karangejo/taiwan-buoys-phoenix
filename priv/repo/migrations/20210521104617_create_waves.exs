defmodule TaiwanBuoys.Repo.Migrations.CreateWaves do
  use Ecto.Migration

  def change do
    create table(:waves) do
      add :email, :string
      add :swell_greater_than, :float
      add :location, :string
      add :last_notification, :utc_datetime

      timestamps()
    end

  end
end
