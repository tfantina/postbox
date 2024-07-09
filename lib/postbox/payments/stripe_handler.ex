defmodule Postbox.StripeHandler do
  @moduledoc "Handles Stripe payments"
  alias Postbox.Letters
  alias Postbox.Letters.Letter

  @behaviour Stripe.WebhookHandler
  require Logger

  @impl true
  @spec handle_event(Stripe.Event.t()) :: {:ok, Letter.t()} | :ok | {:error, :payment_event}
  def handle_event(%Stripe.Event{type: "checkout.session.completed"} = event) do
    with %{data: %{object: %{client_reference_id: id}}} <- event,
         %Letter{} = letter <- Letters.get_letter!(id) do
      Letters.update_letter(letter, %{paid: true})
    else
      err ->
        Logger.warning("PAYMENT ERROR: #{inspect(err)} - CHECKOUT EVENT - #{inspect(event)}")
        {:error, :payment_event}
    end
  end

  # Return HTTP 200 for unhandled events
  @impl true
  def handle_event(_event) do
    :ok
  end
end
