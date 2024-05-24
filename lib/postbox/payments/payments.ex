defmodule Postbox.Payments do
  @moduledoc """
  Functions for sending data to Stripe
  """

  alias Postbox.Letters
  alias Postbox.Letters.Letter

  @doc """
  Takes a letter, or letter ID, and generates params for Stripe 
  """
  @spec stripe_params(Letter.t() | integer()) :: map()
  def stripe_params(%Letter{} = letter) do
    url = PostboxWeb.Endpoint.url()

    %{
      line_items: [
        %{
          price: get_price(letter.country),
          quantity: 1
        }
      ],
      mode: "payment",
      success_url: url <> "/payments/processing",
      cancel_url: url <> "/payments/cancel",
      automatic_tax: %{enabled: false},
      client_reference_id: letter.id,
      metadata: %{letter_id: letter.id}
    }
  end

  def stripe_params(id), do: stripe_params(Letters.get_letter!(id))

  @doc """
  Gets a Price based on the country the letter is addressed too.  
  Eventually we should dynamically pull price IDs but at the moment I think it's fine to hardcode them 
  there are only three.
  """
  @spec get_price(String.t()) :: String.t()
  def get_price(country) do
    case country do
      "Canada" -> price_id(:canada_price)
      "United States" -> price_id(:us_price)
      _ -> price_id(:international_price)
    end
  end

  defp price_id(atom) do
    Application.get_env(:postbox, Postbox.Payments)[atom]
  end
end
