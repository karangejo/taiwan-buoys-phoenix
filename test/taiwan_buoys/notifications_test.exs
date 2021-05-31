defmodule TaiwanBuoys.NotificationsTest do
  use TaiwanBuoys.DataCase

  alias TaiwanBuoys.Notifications

  describe "winds" do
    alias TaiwanBuoys.Notifications.Wind

    @valid_attrs %{email: "some email", kts_greater_than: 42}
    @update_attrs %{email: "some updated email", kts_greater_than: 43}
    @invalid_attrs %{email: nil, kts_greater_than: nil}

    def wind_fixture(attrs \\ %{}) do
      {:ok, wind} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_wind()

      wind
    end

    test "list_winds/0 returns all winds" do
      wind = wind_fixture()
      assert Notifications.list_winds() == [wind]
    end

    test "get_wind!/1 returns the wind with given id" do
      wind = wind_fixture()
      assert Notifications.get_wind!(wind.id) == wind
    end

    test "create_wind/1 with valid data creates a wind" do
      assert {:ok, %Wind{} = wind} = Notifications.create_wind(@valid_attrs)
      assert wind.email == "some email"
      assert wind.kts_greater_than == 42
    end

    test "create_wind/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_wind(@invalid_attrs)
    end

    test "update_wind/2 with valid data updates the wind" do
      wind = wind_fixture()
      assert {:ok, %Wind{} = wind} = Notifications.update_wind(wind, @update_attrs)
      assert wind.email == "some updated email"
      assert wind.kts_greater_than == 43
    end

    test "update_wind/2 with invalid data returns error changeset" do
      wind = wind_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_wind(wind, @invalid_attrs)
      assert wind == Notifications.get_wind!(wind.id)
    end

    test "delete_wind/1 deletes the wind" do
      wind = wind_fixture()
      assert {:ok, %Wind{}} = Notifications.delete_wind(wind)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_wind!(wind.id) end
    end

    test "change_wind/1 returns a wind changeset" do
      wind = wind_fixture()
      assert %Ecto.Changeset{} = Notifications.change_wind(wind)
    end
  end

  describe "waves" do
    alias TaiwanBuoys.Notifications.Wave

    @valid_attrs %{email: "some email", swell_greater_than: 42}
    @update_attrs %{email: "some updated email", swell_greater_than: 43}
    @invalid_attrs %{email: nil, swell_greater_than: nil}

    def wave_fixture(attrs \\ %{}) do
      {:ok, wave} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_wave()

      wave
    end

    test "list_waves/0 returns all waves" do
      wave = wave_fixture()
      assert Notifications.list_waves() == [wave]
    end

    test "get_wave!/1 returns the wave with given id" do
      wave = wave_fixture()
      assert Notifications.get_wave!(wave.id) == wave
    end

    test "create_wave/1 with valid data creates a wave" do
      assert {:ok, %Wave{} = wave} = Notifications.create_wave(@valid_attrs)
      assert wave.email == "some email"
      assert wave.swell_greater_than == 42
    end

    test "create_wave/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_wave(@invalid_attrs)
    end

    test "update_wave/2 with valid data updates the wave" do
      wave = wave_fixture()
      assert {:ok, %Wave{} = wave} = Notifications.update_wave(wave, @update_attrs)
      assert wave.email == "some updated email"
      assert wave.swell_greater_than == 43
    end

    test "update_wave/2 with invalid data returns error changeset" do
      wave = wave_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_wave(wave, @invalid_attrs)
      assert wave == Notifications.get_wave!(wave.id)
    end

    test "delete_wave/1 deletes the wave" do
      wave = wave_fixture()
      assert {:ok, %Wave{}} = Notifications.delete_wave(wave)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_wave!(wave.id) end
    end

    test "change_wave/1 returns a wave changeset" do
      wave = wave_fixture()
      assert %Ecto.Changeset{} = Notifications.change_wave(wave)
    end
  end
end
