defmodule Postbox.LettersTest do
  use Postbox.DataCase

  alias Postbox.Letters

  describe "letter" do
    alias Postbox.Letters.Letter

    import Postbox.LettersFixtures

    @invalid_attrs %{address: nil, content: nil}

    test "list_letter/0 returns all letter" do
      letter = letter_fixture()
      assert Letters.list_letter() == [letter]
    end

    test "get_letter!/1 returns the letter with given id" do
      letter = letter_fixture()
      assert Letters.get_letter!(letter.id) == letter
    end

    test "create_letter/1 with valid data creates a letter" do
      valid_attrs = %{address: "some address", content: "some content"}

      assert {:ok, %Letter{} = letter} = Letters.create_letter(valid_attrs)
      assert letter.address == "some address"
      assert letter.content == "some content"
    end

    test "create_letter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Letters.create_letter(@invalid_attrs)
    end

    test "update_letter/2 with valid data updates the letter" do
      letter = letter_fixture()
      update_attrs = %{address: "some updated address", content: "some updated content"}

      assert {:ok, %Letter{} = letter} = Letters.update_letter(letter, update_attrs)
      assert letter.address == "some updated address"
      assert letter.content == "some updated content"
    end

    test "update_letter/2 with invalid data returns error changeset" do
      letter = letter_fixture()
      assert {:error, %Ecto.Changeset{}} = Letters.update_letter(letter, @invalid_attrs)
      assert letter == Letters.get_letter!(letter.id)
    end

    test "delete_letter/1 deletes the letter" do
      letter = letter_fixture()
      assert {:ok, %Letter{}} = Letters.delete_letter(letter)
      assert_raise Ecto.NoResultsError, fn -> Letters.get_letter!(letter.id) end
    end

    test "change_letter/1 returns a letter changeset" do
      letter = letter_fixture()
      assert %Ecto.Changeset{} = Letters.change_letter(letter)
    end
  end
end
