defmodule TaiwanBuoys.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias TaiwanBuoys.Repo

  alias TaiwanBuoys.Notifications.Wind

  @doc """
  Returns the list of winds.

  ## Examples

      iex> list_winds()
      [%Wind{}, ...]

  """
  def list_winds do
    Repo.all(Wind)
  end

  def list_winds_by_location(location) do
    query =
      from w in Wind,
      where: w.location == ^location

    Repo.all(query)
  end

  @doc """
  Gets a single wind.

  Raises `Ecto.NoResultsError` if the Wind does not exist.

  ## Examples

      iex> get_wind!(123)
      %Wind{}

      iex> get_wind!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wind!(id), do: Repo.get!(Wind, id)

  @doc """
  Creates a wind.

  ## Examples

      iex> create_wind(%{field: value})
      {:ok, %Wind{}}

      iex> create_wind(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wind(attrs \\ %{}) do
    attrs = Map.put(attrs, "last_notification", DateTime.utc_now() |> DateTime.add(-86400))
    %Wind{}
    |> Wind.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wind.

  ## Examples

      iex> update_wind(wind, %{field: new_value})
      {:ok, %Wind{}}

      iex> update_wind(wind, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wind(%Wind{} = wind, attrs) do
    wind
    |> Wind.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wind.

  ## Examples

      iex> delete_wind(wind)
      {:ok, %Wind{}}

      iex> delete_wind(wind)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wind(%Wind{} = wind) do
    Repo.delete(wind)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wind changes.

  ## Examples

      iex> change_wind(wind)
      %Ecto.Changeset{data: %Wind{}}

  """
  def change_wind(%Wind{} = wind, attrs \\ %{}) do
    Wind.changeset(wind, attrs)
  end

  alias TaiwanBuoys.Notifications.Wave

  @doc """
  Returns the list of waves.

  ## Examples

      iex> list_waves()
      [%Wave{}, ...]

  """
  def list_waves do
    Repo.all(Wave)
  end

  def list_waves_by_location(location) do
    query =
      from w in Wave,
      where: w.location == ^location

    Repo.all(query)
  end

  @doc """
  Gets a single wave.

  Raises `Ecto.NoResultsError` if the Wave does not exist.

  ## Examples

      iex> get_wave!(123)
      %Wave{}

      iex> get_wave!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wave!(id), do: Repo.get!(Wave, id)

  @doc """
  Creates a wave.

  ## Examples

      iex> create_wave(%{field: value})
      {:ok, %Wave{}}

      iex> create_wave(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wave(attrs \\ %{}) do
    attrs = Map.put(attrs, "last_notification", DateTime.utc_now() |> DateTime.add(-86400))
    %Wave{}
    |> Wave.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wave.

  ## Examples

      iex> update_wave(wave, %{field: new_value})
      {:ok, %Wave{}}

      iex> update_wave(wave, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wave(%Wave{} = wave, attrs) do
    wave
    |> Wave.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wave.

  ## Examples

      iex> delete_wave(wave)
      {:ok, %Wave{}}

      iex> delete_wave(wave)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wave(%Wave{} = wave) do
    Repo.delete(wave)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wave changes.

  ## Examples

      iex> change_wave(wave)
      %Ecto.Changeset{data: %Wave{}}

  """
  def change_wave(%Wave{} = wave, attrs \\ %{}) do
    Wave.changeset(wave, attrs)
  end
end
