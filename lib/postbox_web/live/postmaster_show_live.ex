defmodule PostboxWeb.PostmasterShowLive do
  alias Postbox.Letters

  use PostboxWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="letter-content blur">
      <%= @letter.content %>
    </div>

    <div class="letter-meta">
      <p>
        <%= @letter.address %>
      </p>
      <p>
        <%= @letter.country %>
      </p>
      <strong>Sent with Postalbox.xyz</strong>
    </div>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    letter = Letters.get_letter!(id)

    socket =
      socket
      |> assign(:letter, letter)

    {:ok, socket}
  end
end
