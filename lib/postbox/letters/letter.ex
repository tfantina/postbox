defmodule Postbox.Letters.Letter do
  use Postbox.Schema
  import Ecto.Changeset

  schema "letter" do
    field :content, :string
    field :address, :string
    field :country, :string
    field :email, :string
    field :paid, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(letter, attrs) do
    letter
    |> cast(attrs, [:content, :address, :country])
    |> validate_required([:content, :address, :country])
  end
end
