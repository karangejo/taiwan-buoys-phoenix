defmodule TaiwanBuoys.Notifications.Wave do
  use Ecto.Schema
  import Ecto.Changeset

  schema "waves" do
    field :email, :string
    field :swell_greater_than, :float
    field :location, :string
    field :last_notification, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(wave, attrs) do
    wave
    |> cast(attrs, [:email, :swell_greater_than, :location, :last_notification])
    |> validate_required([:email, :swell_greater_than, :location, :last_notification])
  end
end
