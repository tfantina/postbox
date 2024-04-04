defmodule PostboxWeb.PageController do
  alias Postbox.Letters
  alias Postbox.Letters.Letter
  alias Postbox.Geography.Countries
  use PostboxWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> assign(:letter, Letter.changeset(%{}))
    |> assign(:countries, Countries.all())
    |> render(:home, layout: false)
  end

  def post(conn, %{"letter" => params}) do
    case Letters.create_letter(params) do
      {:ok, letter} ->
        conn
        |> put_session(:letter, letter)
        |> redirect(to: ~p"/payments")

      {:error, _err} ->
        conn
        |> assign(:letter, Letter.changeset(params))
        |> assign(:countries, Countries.all())
        |> put_flash(:error, "Problem sending please ensure your letter is filled out")
        |> render(:home, layout: false)
    end
  end
end
