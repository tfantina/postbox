defmodule Postbox.Repo.Migrations.AddDeletedAtToLetter do
  use Ecto.Migration

  def up do
    alter table(:letter) do
      add :deleted_at, :naive_datetime
    end
  end

  def down do
    alter table(:letter) do
      remove :deleted_at
    end
  end
end
