defmodule TaiwanBuoysWeb.WindController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.Notifications
  alias TaiwanBuoys.Notifications.Wind
  alias TaiwanBuoys.Scraper
  alias TaiwanBuoys.Email

  def index(conn, _params) do
    winds = Notifications.list_winds()
    render(conn, "index.html", winds: winds)
  end

  def new(conn, _params) do
    changeset = Notifications.change_wind(%Wind{})
    locations =  Scraper.get_locations
    render(conn, "new.html", changeset: changeset, location_options: locations)
  end

  def create(conn, %{"wind" => wind_params}) do
    case Notifications.create_wind(wind_params) do
      {:ok, wind} ->
        Task.start(fn -> Email.deliver_welcome(wind) end)
        conn
        |> put_flash(:info, "Wind notification created successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wind = Notifications.get_wind!(id)
    render(conn, "show.html", wind: wind)
  end

  def edit(conn, %{"id" => id}) do
    wind = Notifications.get_wind!(id)
    changeset = Notifications.change_wind(wind)
    render(conn, "edit.html", wind: wind, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wind" => wind_params}) do
    wind = Notifications.get_wind!(id)

    case Notifications.update_wind(wind, wind_params) do
      {:ok, _wind} ->
        conn
        |> put_flash(:info, "Wind updated successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wind: wind, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wind = Notifications.get_wind!(id)
    {:ok, _wind} = Notifications.delete_wind(wind)

    conn
    |> put_flash(:info, "Wind notification deleted successfully.")
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
