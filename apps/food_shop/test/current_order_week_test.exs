defmodule FoodCurrentOrderWeekTest do
  use ExUnit.Case
  alias Timex.Date
  doctest FoodShop

  @due_time {13, 30, 0} # 1:30pm

  test "when today == monday" do
    shop = show_shop Date.from({2016, 2, 22})
    assert shop.current_order.week_range == "del 29 de febrero al 4 de marzo"
  end

  test "when today == tuesday" do
    shop = show_shop Date.from({2016, 2, 23})
    assert shop.current_order.week_range == "del 29 de febrero al 4 de marzo"
  end

  test "when today == friday" do
    shop = show_shop Date.from({2016, 2, 26})
    assert shop.current_order.week_range == "del 29 de febrero al 4 de marzo"
  end

  test "when today == saturday" do
    shop = show_shop Date.from({{2016, 2, 27}, {10, 0, 0}})
    assert shop.current_order.week_range == "del 29 de febrero al 4 de marzo"
  end

  test "when today == saturday after order due time" do
    shop = show_shop Date.from({{2016, 2, 27}, {13, 30, 1}})
    assert shop.current_order.week_range == "del 7 al 11 de marzo"
  end

  test "when today == sunday" do
    shop = show_shop Date.from({2016, 2, 28})
    assert shop.current_order.week_range == "del 7 al 11 de marzo"
  end

  defp repo do
    MexiFoodRepoStub
  end

  defp show_shop(current_time) do
    FoodShop.show_shop(repo: repo, current_time: current_time, order_due_time: @due_time)
  end
end
