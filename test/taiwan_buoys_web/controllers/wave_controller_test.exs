defmodule TaiwanBuoysWeb.WaveControllerTest do
  use TaiwanBuoysWeb.ConnCase

  alias TaiwanBuoys.Notifications

  @create_attrs %{email: "some email", swell_greater_than: 42}
  @update_attrs %{email: "some updated email", swell_greater_than: 43}
  @invalid_attrs %{email: nil, swell_greater_than: nil}

  def fixture(:wave) do
    {:ok, wave} = Notifications.create_wave(@create_attrs)
    wave
  end

  describe "index" do
    test "lists all waves", %{conn: conn} do
      conn = get(conn, Routes.wave_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Waves"
    end
  end

  describe "new wave" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.wave_path(conn, :new))
      assert html_response(conn, 200) =~ "New Wave"
    end
  end

  describe "create wave" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.wave_path(conn, :create), wave: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.wave_path(conn, :show, id)

      conn = get(conn, Routes.wave_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Wave"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.wave_path(conn, :create), wave: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wave"
    end
  end

  describe "edit wave" do
    setup [:create_wave]

    test "renders form for editing chosen wave", %{conn: conn, wave: wave} do
      conn = get(conn, Routes.wave_path(conn, :edit, wave))
      assert html_response(conn, 200) =~ "Edit Wave"
    end
  end

  describe "update wave" do
    setup [:create_wave]

    test "redirects when data is valid", %{conn: conn, wave: wave} do
      conn = put(conn, Routes.wave_path(conn, :update, wave), wave: @update_attrs)
      assert redirected_to(conn) == Routes.wave_path(conn, :show, wave)

      conn = get(conn, Routes.wave_path(conn, :show, wave))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, wave: wave} do
      conn = put(conn, Routes.wave_path(conn, :update, wave), wave: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wave"
    end
  end

  describe "delete wave" do
    setup [:create_wave]

    test "deletes chosen wave", %{conn: conn, wave: wave} do
      conn = delete(conn, Routes.wave_path(conn, :delete, wave))
      assert redirected_to(conn) == Routes.wave_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.wave_path(conn, :show, wave))
      end
    end
  end

  defp create_wave(_) do
    wave = fixture(:wave)
    %{wave: wave}
  end
end
