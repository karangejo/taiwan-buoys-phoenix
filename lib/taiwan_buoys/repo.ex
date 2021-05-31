defmodule TaiwanBuoys.Repo do
  use Ecto.Repo,
    otp_app: :taiwan_buoys,
    adapter: Ecto.Adapters.Postgres
end
