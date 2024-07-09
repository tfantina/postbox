defmodule PostboxWeb.PostmasterLive do
  alias Postbox.Letters
  alias Postbox.Letters.Letter
  alias Postbox.Repo
  use PostboxWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Letters</h1>
    <table>
      <thead>
        <th>Date</th>
        <th>Address</th>
        <th>Country</th>
        <th>Paid?</th>
        <th>Print</th>
        <th>status</th>
      </thead>
      <tbody>
        <%= for change <- @letters_changesets do %>
          <.simple_form
            for={@form}
            id={"change-#{change.data.id}"}
            phx-change="save"
            phx-value-id={change.data.id}
          >
            <tr>
              <td><%= change.data.inserted_at %></td>
              <td><%= change.data.address %></td>
              <td><%= change.data.country %></td>
              <td><%= change.data.paid %></td>
              <td>
                <.link href={~p"/postmaster/#{change.data.id}"}>Print</.link>
              </td>
              <td>
                <.input
                  type="select"
                  field={change.data.status}
                  name="status"
                  id={change.data.id}
                  value={change.data.status}
                  options={["printed", "sent", "refunded"]}
                />
              </td>
              <td>
                <button
                  role="button"
                  phx-value-id={change.data.id}
                  phx-click="delete"
                  data-confirm="Are you sure?"
                >
                  Delete
                </button>
              </td>
            </tr>
          </.simple_form>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    socket =
      socket
      |> assign(form: form)
      |> assign(letters_changesets: Letters.letters_changesets())
      |> assign(form_opts: ["new", "printed", "sent", "refunded", "other"])

    {:ok, socket, temporary_assigns: [form: form]}
  end

  def handle_event("save", params, socket) do
    %{"status" => status, "id" => id} = params
    %{assigns: %{letters_changesets: changesets}} = socket

    chagneset = Enum.find(changesets, &(&1.data.id == id))

    chagneset.data
    |> Letter.changeset_status(%{"status" => status})
    |> Repo.update()

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    %{assigns: %{letters_changesets: changesets}} = socket

    id
    |> Letters.get_letter!()
    |> Letters.soft_delete_letter()
    |> case do
      {:ok, %{id: id}} ->
        changeset = Enum.find(changesets, &(&1.data.id == id))
        changesets = changesets -- [changeset]
        socket = assign(socket, :changesets, changesets)
        {:noreply, socket}

      _res ->
        socket = put_flash(socket, :error, "Could not delete letter")
        {:noreply, socket}
    end
  end
end
