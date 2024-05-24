defmodule Postbox.Letters do
  @moduledoc """
  The Letters context.
  """

  import Ecto.Query, warn: false
  alias Postbox.Repo

  alias Postbox.Letters.Letter

  @doc """
  Returns the list of letter.

  ## Examples

      iex> list_letter()
      [%Letter{}, ...]

  """
  def list_letter do
    Repo.all(Letter)
  end

  @doc """
  Gets a single letter.

  Raises `Ecto.NoResultsError` if the Letter does not exist.

  ## Examples

      iex> get_letter!(123)
      %Letter{}

      iex> get_letter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_letter!(id), do: Repo.get!(Letter, id)

  @doc """
  Creates a letter.

  ## Examples

      iex> create_letter(%{field: value})
      {:ok, %Letter{}}

      iex> create_letter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_letter(attrs \\ %{}) do
    %Letter{}
    |> Letter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a letter.

  ## Examples

      iex> update_letter(letter, %{field: new_value})
      {:ok, %Letter{}}

      iex> update_letter(letter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_letter(%Letter{} = letter, attrs) do
    letter
    |> Letter.changeset_paid(attrs)
    |> Repo.update()
  end

  def update_letter(id, attrs) do
    id |> get_letter!() |> update_letter(attrs)
  end

  @doc """
  Deletes a letter.

  ## Examples

      iex> delete_letter(letter)
      {:ok, %Letter{}}

      iex> delete_letter(letter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_letter(%Letter{} = letter) do
    Repo.delete(letter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking letter changes.

  ## Examples

      iex> change_letter(letter)
      %Ecto.Changeset{data: %Letter{}}

  """
  def change_letter(%Letter{} = letter, attrs \\ %{}) do
    Letter.changeset(letter, attrs)
  end
end
