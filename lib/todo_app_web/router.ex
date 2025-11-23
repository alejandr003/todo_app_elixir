defmodule TodoAppWeb.Router do
  use TodoAppWeb, :router
  import Phoenix.LiveView.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TodoAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # Endpoint para autenticación
  scope "/api", TodoAppWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
    post "/password/forgot", AuthController, :forgot_password
    post "/password/reset", AuthController, :reset_password
  end

  # Endpoint accesible solo si esta autenticado
  scope "/api", TodoAppWeb do
    pipe_through [:api, TodoAppWeb.Plugs.Auth]

    post "/logout", AuthController, :logout
    resources "/notes", Notes.NotesController, except: [:new, :edit]
  end

  # Ruta para formulario de cambio de contraseña
  scope "/", TodoAppWeb do
    pipe_through :browser

    get "/reset-password", PasswordController, :reset_form
    post "/reset-password", PasswordController, :reset_password
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todo_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TodoAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
