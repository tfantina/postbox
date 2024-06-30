defmodule Postbox.StripeHandler do
  @behaviour Plug

  alias Plug.Conn

  def init(config), do: config

  def call(%{request_path: "/webhook/payments"} = conn, _params) do
    signing_secret = Application.get_env(:stripity_stripe, :webhook_key)
    [stripe_signature] = Plug.Conn.get_req_header(conn, "stripe-signature")

    with {:ok, body, _} = Plug.Conn.read_body(conn),
         {:ok, stripe_event} =
           Stripe.Webhook.construct_event(body, stripe_signature, signing_secret) do
      Plug.Conn.assign(conn, :stripe_event, stripe_event)
    else
      err ->
        conn
        |> Conn.send_resp(:bad_request, err)
        |> Conn.halt()
    end
  end

  def call(conn, _), do: conn
end
