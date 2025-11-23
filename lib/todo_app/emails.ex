defmodule TodoApp.Emails do
  import Swoosh.Email
  alias TodoApp.Mailer
  require EEx

  EEx.function_from_file(:defp, :password_reset_template,
    "priv/templates/emails/password_reset.html.heex",
    [:assigns])

  EEx.function_from_file(:defp, :welcome_template,
    "priv/templates/emails/welcome.html.heex",
    [:assigns])

  def send_welcome_email(user, url) do
    assigns = %{
      user_name: user.name,
      url: url
    }
    html_content = welcome_template(assigns)

    new()
    |> to({user.name, user.email})
    |> from({"TodoApp", "noreply@todoapp.com"})
    |> subject("¡Bienvenido a TodoApp!")
    |> html_body(html_content)
    |> Mailer.deliver()
  end

  def send_password_reset_email(user, token, url) do
    reset_url = "#{url}/reset-password?token=#{token}"
    api_reset_url = "#{url}/api/reset_password"
    login_url = "#{url}/login"

    assigns = %{
      user_name: user.name,
      token: token,
      reset_url: reset_url,
      api_reset_url: api_reset_url,
      login_url: login_url
    }

    html_content = password_reset_template(assigns)

    new()
    |> to({user.name, user.email})
    |> from({"TodoApp", "noreply@todoapp.com"})
    |> subject("Recupera tu contraseña - TodoApp")
    |> html_body(html_content)
    |> Mailer.deliver()
  end
end
