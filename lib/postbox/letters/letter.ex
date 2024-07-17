defmodule Postbox.Letters.Letter do
  @moduledoc false
  use Postbox.Schema
  import Ecto.Changeset

  schema "letter" do
    field :content, :string
    field :address_line_1, :string
    field :address_line_2, :string
    field :city, :string
    field :province, :string
    field :postal_code, :string
    field :country, :string
    field :email, :string
    field :paid, :boolean, default: false
    field :status, :string, default: "new"
    field :deleted_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @fields ~w[content address_line_1 address_line_2 city province postal_code country email]a
  @required @fields -- ~w[address_line_2 province email]a

  @doc false
  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(letter, attrs) do
    letter
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end

  def changeset_paid(letter, attrs) do
    letter
    |> cast(attrs, [:paid])
    |> validate_required([:paid])
  end

  def changeset_status(letter, attrs) do
    letter
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_inclusion(:status, ["new", "printed", "sent", "refunded", "other"])
  end

  def changeset_delete(letter) do
    timestamp = %{deleted_at: NaiveDateTime.utc_now()}

    cast(letter, timestamp, [:deleted_at])
  end
end
