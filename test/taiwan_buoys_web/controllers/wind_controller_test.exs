defmodule TaiwanBuoysWeb.WindControllerTest do
  use TaiwanBuoysWeb.ConnCase

  alias TaiwanBuoys.Notifications

  @create_attrs %{email: "some email", kts_greater_than: 42}
  @update_attrs %{email: "some updated email", kts_greater_than: 43}
  @invalid_attrs %{email: nil, kts_greater_than: nil}

  def fixture(:wind) do
    {:ok, wind} = Notifications.create_wind(@create_attrs)
    wind
  end

  describe "index" do
    test "lists all winds", %{conn: conn} do
      conn = get(conn, Routes.wind_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Winds"
    end
  end

  describe "new wind" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.wind_path(conn, :new))
      assert html_response(conn, 200) =~ "New Wind"
    end
  end

  describe "create wind" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.wind_path(conn, :create), wind: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.wind_path(conn, :show, id)

      conn = get(conn, Routes.wind_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Wind"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.wind_path(conn, :create), wind: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wind"
    end
  end

  describe "edit wind" do
    setup [:create_wind]

    test "renders form for editing chosen wind", %{conn: conn, wind: wind} do
      conn = get(conn, Routes.wind_path(conn, :edit, wind))
      assert html_response(conn, 200) =~ "Edit Wind"
    end
  end

  describe "update wind" do
    setup [:create_wind]

    test "redirects when data is valid", %{conn: conn, wind: wind} do
      conn = put(conn, Routes.wind_path(conn, :update, wind), wind: @update_attrs)
      assert redirected_to(conn) == Routes.wind_path(conn, :show, wind)

      conn = get(conn, Routes.wind_path(conn, :show, wind))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, wind: wind} do
      conn = put(conn, Routes.wind_path(conn, :update, wind), wind: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wind"
    end
  end

  describe "delete wind" do
    setup [:create_wind]

    test "deletes chosen wind", %{conn: conn, wind: wind} do
      conn = delete(conn, Routes.wind_path(conn, :delete, wind))
      assert redirected_to(conn) == Routes.wind_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.wind_path(conn, :show, wind))
      end
    end
  end

  defp create_wind(_) do
    wind = fixture(:wind)
    %{wind: wind}
  end
end
