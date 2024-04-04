defmodule Postbox.Repo.Migrations.CreateLetter do
  use Postbox.Migration

  def change do
    create table(:letter, primary_key: false) do
      uuid_primary_key()
      add :content, :string
      add :address, :string
      add :country, :string
      add :email, :string
      add :paid, :boolean, default: false
      add :status, :string, default: "new"

      timestamps(type: :utc_datetime)
    end
  end
end
