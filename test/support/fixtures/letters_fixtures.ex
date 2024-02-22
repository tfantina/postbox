defmodule Postbox.LettersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Postbox.Letters` context.
  """

  @doc """
  Generate a letter.
  """
  def letter_fixture(attrs \\ %{}) do
    {:ok, letter} =
      attrs
      |> Enum.into(%{
        address: "some address",
        content: "some content",
        country: "US",
        paid: false
      })
      |> Postbox.Letters.create_letter()

    letter
  end
end
