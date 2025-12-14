defmodule TaiwanBuoysWeb.Plugs.SetLocale do
  import Plug.Conn


  @locales ~w(en zh-TW)

  def init(default), do: default 

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _opts) when locale in @locales do
    case get_locale(conn) do
      {:ok, ^locale} -> conn
      _ -> put_resp_cookie(conn, "locale", locale, max_age: 10 * 24 * 60 * 60)
    end
  end

  def call(conn, default_locale) do
    case get_locale(conn) do
      {:ok, _locale} -> conn
      _ -> put_resp_cookie(conn, "locale", default_locale, max_age: 10 * 24 * 60 * 60)
    end
  end

  def get_locale(conn) do
    validate_locale(conn.cookies["locale"])
  end
  
  defp validate_locale(locale) when locale in @locales, do: {:ok, locale}
  defp validate_locale(_), do: {:error, :invalid_locale}
end
