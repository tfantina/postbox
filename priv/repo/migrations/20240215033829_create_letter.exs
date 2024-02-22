defmodule Postbox.Repo.Migrations.CreateLetter do
  use Ecto.Migration

  def change do
    create table(:letter) do
      add :content, :string
      add :address, :string
      add :country, :string
      add :email, :string
      add :paid, :boolean, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
