defmodule Postbox.Repo.Migrations.UpdateLetterWithAdditionalAddressFields do
  use Ecto.Migration

  def up do
    alter table(:letter) do
      add :address_line_2, :string
      add :city, :string
      add :province, :string
      add :postal_code, :string
    end

    rename table(:letter), :address, to: :address_line_1
  end

  def down do
    alter table(:letter) do
      remove :address_line_2
      remove :city
      remove :province
      remove :postal_code
    end

    rename table(:letter), :address_line_1, to: :address
  end
end
