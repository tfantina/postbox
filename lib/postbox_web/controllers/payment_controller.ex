defmodule PostboxWeb.PaymentController do
  @moduledoc false
  alias Postbox.{Letters, Payments}
  alias Stripe.Checkout.Session, as: Stripe
  use PostboxWeb, :controller

  def index(conn, _params) do
    %{id: id} = get_session(conn, :letter)

    params = Payments.stripe_params(id)

    {:ok, session} = Stripe.create(params)

    # conn
    # |> assign(:letter, letter)
    # |> render(:index, layout: false)

    conn
    |> put_status(303)
    |> redirect(external: session.url)
  end

  def success(conn, _params) do
    %{id: id} = get_session(conn, :letter)

    case Letters.update_letter(id, %{paid: true}) do
      {:ok, _letter} ->
        conn
        |> put_flash(
          :letter_succces,
          "Payment received we will mail your letter in the next few days!"
        )
        |> render(:success, layout: false)

      {:error, _} ->
        "error"
    end
  end

  def cancel(conn, _params) do
    conn
    |> put_flash(
      :letter_error,
      "Your friends can't wait to hear from you! Click 'post' to checkout"
    )
    |> redirect(to: ~p"/")
  end
end
