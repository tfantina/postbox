defmodule Postbox.PaymentsTest do
  use Postbox.DataCase
  alias Postbox.Payments

  import Postbox.LettersFixtures

  describe "stripe_params" do
    test "returns the correct value given the country" do
      ca_letter = letter_fixture(%{country: "Canada"})
      us_letter = letter_fixture(%{country: "United States"})
      it_letter = letter_fixture(%{country: "Italy"})

      %{line_items: [res_li], mode: "payment"} = Payments.stripe_params(ca_letter)
      assert %{price: "price_can", quantity: 1} = res_li
      %{line_items: [res_li], mode: "payment"} = Payments.stripe_params(us_letter)
      assert %{price: "price_us", quantity: 1} = res_li
      %{line_items: [res_li], mode: "payment"} = Payments.stripe_params(it_letter)
      assert %{price: "price_intl", quantity: 1} = res_li
    end
  end
end
