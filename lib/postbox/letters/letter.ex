defmodule Postbox.Letters.Letter do
  @moduledoc false
  use Postbox.Schema
  import Ecto.Changeset

  schema "letter" do
    field :content, :string
    field :address, :string
    field :country, :string
    field :email, :string
    field :paid, :boolean, default: false
    field :status, :string, default: "new"
    field :deleted_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(letter, attrs) do
    letter
    |> cast(attrs, [:content, :address, :country])
    |> validate_required([:content, :address, :country])
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
