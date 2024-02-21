defmodule PostboxWeb.PaymentController do
  use PostboxWeb, :controller

  def index(conn, params) do
    letter = get_session(conn, :letter)

    conn
    |> assign(:letter, letter)
    |> render(:index, layout: false)
  end
end
