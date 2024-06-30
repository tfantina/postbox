defmodule PostboxWeb.PaymentController do
  @moduledoc false
  alias Postbox.{Letters, Payments}
  alias Stripe.Checkout.Session, as: Stripe
  alias Postbox.Letters.Letter
  use PostboxWeb, :controller

  def index(conn, _params) do
    %{id: id} = letter = get_session(conn, :letter)

    params = Payments.stripe_params(id)

    {:ok, session} = Stripe.create(params)

    conn
    |> put_status(303)
    |> put_session(:letter, letter)
    |> redirect(external: session.url)
  end

  def success(conn, _params) do
    conn
    |> put_flash(
      :letter_success,
      "Payment received we will mail your letter in the next few days!"
    )
    |> render(:success, layout: false)
  end

  def error(conn, _params) do
    conn
    |> put_flash(
      :letter_error,
      "There was a problem with your payment please try again or contact us!"
    )
    |> render(:error, layout: false)
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
