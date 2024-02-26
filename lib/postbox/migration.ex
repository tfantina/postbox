defmodule Postbox.Migration do
  @moduledoc false

  @doc false
  defmacro __using__(_) do
    quote do
      use Ecto.Migration
      import Postbox.Migration
    end
  end

  @doc false
  defmacro uuid_references(table, opts \\ []) do
    sanitized_opts = Keyword.merge([type: :uuid, on_delete: :restrict], opts)

    quote do
      unquote(Migration).references(unquote(table), unquote(sanitized_opts))
    end
  end

  @doc false
  defmacro uuid_primary_key(opts \\ []) do
    quote do
      opts = Keyword.merge([primary_key: true, null: false], unquote(opts))
      Migration.add(:id, :uuid, opts)
    end
  end
end
