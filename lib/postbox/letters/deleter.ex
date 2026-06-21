defmodule Postbox.Letters.Deleter do
  use GenServer

  @impl true
  def init(state) do
    schedule_check()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do

    schedule_check()

    {:noreply, state}
  end

  defp schedule_check do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end
end
