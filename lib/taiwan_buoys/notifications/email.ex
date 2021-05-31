defmodule TaiwanBuoys.Email do

  @wave_wait_period 24
  @wind_wait_period 24
  #@taiwanbuoys_url "https://taiwanbuoys.com"
  @taiwanbuoys_url "http://localhost:4000"
  @welcome_subject "Hello From Taiwan Buoys!"
  @notification_subject "Notification From Taiwan Buoys!"

  alias TaiwanBuoys.Notifications
  alias TaiwanBuoys.ZohoMailer
  alias TaiwanBuoys.Notifications.Wave
  alias TaiwanBuoys.Notifications.Wind
  alias TaiwanBuoys.Scraper.BuoyData

  def delete_wind_link(wind) do
    @taiwanbuoys_url <> TaiwanBuoysWeb.Router.Helpers.wind_path(TaiwanBuoysWeb.Endpoint, :delete, wind)
  end

  def delete_wave_link(wave) do
    @taiwanbuoys_url <> TaiwanBuoysWeb.Router.Helpers.wave_path(TaiwanBuoysWeb.Endpoint, :delete, wave)
  end

  def deliver_welcome(%Wave{email: email} = wave) do

    email = %Mailman.Email{
      subject: @welcome_subject,
      from: ZohoMailer.from,
      to: [email],
      text: "You have signed up for notifications from taiwanbuoys.com! We will send you max 1 notification a day!\n If you did not sign up for these notifications please unsubscribe by following the link below:\n #{delete_wave_link(wave)}",
    }

    ZohoMailer.deliver(email)
  end

  def deliver_welcome(%Wind{email: email} = wind) do

    email = %Mailman.Email{
      subject: @welcome_subject,
      from: ZohoMailer.from,
      to: [email],
      text: "You have signed up for notifications from taiwanbuoys.com! We will send you max 1 notification a day!\n If you did not sign up for these notifications please unsubscribe by following the link below:\n #{delete_wind_link(wind)}",
    }

    ZohoMailer.deliver(email)
  end


  def send_email(email, :wind_notification, params, location, %Wind{} = wind) do
    email = %Mailman.Email{
      subject: @notification_subject,
      from: ZohoMailer.from,
      to: [email],
      text: wind_email_template(location, params, wind),
    }

    ZohoMailer.deliver(email)
  end

  def send_email(email, :wave_notification, params, location, %Wave{} = wave) do
    email = %Mailman.Email{
      subject: @notification_subject,
      from: ZohoMailer.from,
      to: [email],
      text: wave_email_template(location, params, wave),
    }

    ZohoMailer.deliver(email)
  end

  def wave_email_template(loc, %BuoyData{} = params, %Wave{} = wave) do
    """
    Just letting you know the current conditions for the #{loc} buoy at #{params.date_time}:
    Wave Height: #{params.wave_height}
    Wave Period: #{params.wave_period}
    Wave Direction: #{params.wave_direction}

    If you do not want to receive any more of these notifications please unsubscribe by following the link below:
    #{delete_wave_link(wave)}
    """
  end

  def wind_email_template(loc, %BuoyData{} = params, %Wind{} = wind) do
    """
    Just letting you know the current conditions for the #{loc} buoy at #{params.date_time}:
    Wind Speed: #{params.mean_wind_speed}
    Wind Direction: #{params.wind_direction}

    If you do not want to receive any more of these notifications please unsubscribe by following the link below:
    #{delete_wind_link(wind)}
    """
  end

  def check_wave_notifications(location, %BuoyData{wave_height: current_wave_height} = params) do
    for wave_notification <- Notifications.list_waves_by_location(location) do
      IO.inspect(current_wave_height)
      IO.inspect(wave_notification.swell_greater_than)
      if wave_notification.swell_greater_than <= String.to_float(current_wave_height) and time_between_last_notification(wave_notification.last_notification) >= @wave_wait_period do
        send_email(wave_notification.email, :wave_notification, params, location, wave_notification)
        Notifications.update_wave(wave_notification, %{"last_notification" => DateTime.utc_now()})
      end
    end
  end

  def check_wind_notifications(location, %BuoyData{mean_wind_speed: current_wind_speed} = params) do
    for wind_notification <- Notifications.list_winds_by_location(location) do
      if wind_notification.kts_greater_than <= current_wind_speed and time_between_last_notification(wind_notification.last_notification)  >= @wind_wait_period do
        send_email(wind_notification.email, :wind_notification, params, location, wind_notification)
        Notifications.update_wind(wind_notification, %{"last_notification" => DateTime.utc_now()})
      end
    end
  end

  def time_between_last_notification(last_notification) do
    seconds_to_hours(DateTime.diff(DateTime.utc_now(), last_notification))
  end

  def seconds_to_hours(seconds) do
    seconds / 3600
  end
end
