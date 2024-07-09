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

    test "list_letter/0 does not return a soft deleted letter" do
      letter = letter_fixture()
      _deleted_letter = letter_fixture() |> Letters.soft_delete_letter()
      assert Letters.list_letter() == [letter]
    end

    test "get_letter!/1 returns the letter with given id" do
      letter = letter_fixture()
      assert Letters.get_letter!(letter.id) == letter
    end

    test "create_letter/1 with valid data creates a letter" do
      valid_attrs = %{address: "some address", country: "Canada", content: "some content"}

      assert {:ok, %Letter{} = letter} = Letters.create_letter(valid_attrs)
      assert letter.address == "some address"
      assert letter.content == "some content"
    end

    test "create_letter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Letters.create_letter(@invalid_attrs)
    end

    test "update_letter/2 will update a letter's status to paid" do
      letter = letter_fixture()
      update_attrs = %{paid: true}

      assert {:ok, %Letter{} = letter} = Letters.update_letter(letter, update_attrs)
      assert letter.paid
    end

    test "delete_letter/1 deletes the letter" do
      letter = letter_fixture()
      assert {:ok, %Letter{}} = Letters.delete_letter(letter)
      assert_raise Ecto.NoResultsError, fn -> Letters.get_letter!(letter.id) end
    end

    test "soft_delete_letter/1 soft deletes the letter" do
      letter = letter_fixture()
      assert {:ok, %Letter{deleted_at: del}} = Letters.soft_delete_letter(letter)
      assert not is_nil(del)
    end

    test "change_letter/1 returns a letter changeset" do
      letter = letter_fixture()
      assert %Ecto.Changeset{} = Letters.change_letter(letter)
    end
  end
end
