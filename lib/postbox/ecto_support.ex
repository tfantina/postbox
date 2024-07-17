defmodule Postbox.EctoSupport do
  @moduledoc false

  alias Ecto.{Multi, Query}
  alias NaiveDateTime, as: NDT

  @doc """
  A take on Ecto.Multi's `update_all` and `delete_all`. Soft deletes is a pattern
  used heavily in PacksizeNow this is a helper to soft delete several records at once.

  Called the same way as the above mentioned functions (see Ecto docs for details).

  At the moment this is a fairly basic implementation and may not cover every case that the
  aforementioned functions do.

  The private helper functions here are taken directly from the Ecto core.
  """
  @spec soft_delete_all(Multi.t(), atom(), fun() | Query.t(), keyword()) :: Multi.t()
  def soft_delete_all(multi, name, func, opts \\ [])

  def soft_delete_all(multi, name, func, opts) when is_function(func) do
    Multi.run(
      multi,
      name,
      operation_fun({:soft_delete_all, func, [set: [deleted_at: NDT.utc_now()]]}, opts)
    )
  end

  def soft_delete_all(multi, name, queryable, opts) do
    add_operation(multi, name, {:update_all, queryable, [set: [deleted_at: NDT.utc_now()]], opts})
  end

  defp operation_fun({:soft_delete_all, fun, updates}, opts) do
    fn repo, changes ->
      {:ok, repo.update_all(fun.(changes), updates, opts)}
    end
  end

  defp add_operation(%Multi{} = multi, name, operation) do
    %{operations: operations, names: names} = multi

    if MapSet.member?(names, name) do
      raise "#{Kernel.inspect(name)} is already a member of the Ecto.Multi: \n#{Kernel.inspect(multi)}"
    else
      %{multi | operations: [{name, operation} | operations], names: MapSet.put(names, name)}
    end
  end
end
