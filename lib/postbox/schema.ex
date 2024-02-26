defmodule Postbox.Schema do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Postbox.Schema
      @type t :: %__MODULE__{}
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
