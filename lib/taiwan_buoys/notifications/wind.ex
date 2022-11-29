defmodule TaiwanBuoys.Notifications.Wind do
  use Ecto.Schema
  import Ecto.Changeset

  schema "winds" do
    field(:email, :string)
    field(:kts_greater_than, :integer)
    field(:location, :string)
    field(:last_notification, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(wind, attrs) do
    wind
    |> cast(attrs, [:email, :kts_greater_than, :location, :last_notification])
    |> validate_required([:email, :kts_greater_than, :location, :last_notification])
  end
end
