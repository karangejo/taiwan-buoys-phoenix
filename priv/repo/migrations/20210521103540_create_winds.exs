defmodule TaiwanBuoys.Repo.Migrations.CreateWinds do
  use Ecto.Migration

  def change do
    create table(:winds) do
      add :email, :string
      add :kts_greater_than, :integer
      add :location, :string
      add :last_notification, :utc_datetime

      timestamps()
    end

  end
end
