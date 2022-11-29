defmodule TaiwanBuoysWeb.WaveController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.Notifications
  alias TaiwanBuoys.Notifications.Wave
  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.Email

  def index(conn, _params) do
    waves = Notifications.list_waves()
    render(conn, "index.html", waves: waves)
  end

  def new(conn, _params) do
    changeset = Notifications.change_wave(%Wave{})
    locations = DataSources.get_locations()
    render(conn, "new.html", changeset: changeset, location_options: locations)
  end

  def create(conn, %{"wave" => wave_params}) do
    case Notifications.create_wave(wave_params) do
      {:ok, wave} ->
        Task.start(fn -> Email.deliver_welcome(wave) end)

        conn
        |> put_flash(:info, "Wave notification created successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          location_options: DataSources.get_locations()
        )
    end
  end

  def show(conn, %{"id" => id}) do
    wave = Notifications.get_wave!(id)
    render(conn, "show.html", wave: wave)
  end

  def edit(conn, %{"id" => id}) do
    wave = Notifications.get_wave!(id)
    changeset = Notifications.change_wave(wave)
    render(conn, "edit.html", wave: wave, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wave" => wave_params}) do
    wave = Notifications.get_wave!(id)

    case Notifications.update_wave(wave, wave_params) do
      {:ok, _wave} ->
        conn
        |> put_flash(:info, "Wave updated successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wave: wave, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wave = Notifications.get_wave!(id)
    {:ok, _wave} = Notifications.delete_wave(wave)

    conn
    |> put_flash(:info, "Wave notification deleted successfully.")
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
