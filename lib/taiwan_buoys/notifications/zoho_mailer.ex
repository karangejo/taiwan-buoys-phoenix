defmodule TaiwanBuoys.ZohoMailer do
  @from_email "taiwan.buoys.notify@karangejo.com"

  def from do
    @from_email
  end

  def deliver(email) do
    Mailman.deliver(email, config())
  end

  def config do
    %Mailman.Context{
      config: %Mailman.SmtpConfig{
        relay: "smtp.zoho.com",
        username: @from_email,
        password: System.get_env("ZOHO_TW_BUOYS_PASSWORD"),
        port: 587,
        tls: :always,
        auth: :always
      },
      composer: %Mailman.EexComposeConfig{}
    }
  end
end
