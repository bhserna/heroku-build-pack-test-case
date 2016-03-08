defmodule FoodSelectionTest do
  use ExUnit.Case
  doctest FoodShop

  test "when user selects a dish -> all dishes from the same section and day are disabled" do
    selection = %{"e-fr" => %{ "monday" => "1" }}
    shop = show_shop(selection)

    assert options_matrix(shop.entries, "monday") == %{
      "e-fr" => %{selected?: true,  disabled?: false},
      "e-to" => %{selected?: false, disabled?: true },
      "e-gu" => %{selected?: false, disabled?: true }}

    for day <- ["tuesday", "wednesday", "thursday", "friday"] do
      assert options_matrix(shop.entries, day) == %{
        "e-fr" => %{selected?: false, disabled?: false},
        "e-to" => %{selected?: false, disabled?: false},
        "e-gu" => %{selected?: false, disabled?: false}}
    end

    for day <- ["monday", "tuesday", "wednesday", "thursday", "friday"] do
      assert options_matrix(shop.main_dishes, day) == %{
        "m-tb" => %{selected?: false, disabled?: false},
        "m-tm" => %{selected?: false, disabled?: false},
        "m-ts" => %{selected?: false, disabled?: false}}

      assert options_matrix(shop.desserts, day) == %{
        "d-fl" => %{selected?: false, disabled?: false},
        "d-gl" => %{selected?: false, disabled?: false}}
    end
  end

  test "when user selects a day -> all dishes from the same section and day are disabled" do
    selection = %{
      "e-fr" => %{ "monday" => "1" },
      "m-ts" => %{ "monday" => "1" },
      "d-gl" => %{ "monday" => "1" }}

    shop = show_shop(selection)

    assert options_matrix(shop.entries, "monday") == %{
      "e-fr" => %{selected?: true,  disabled?: false},
      "e-to" => %{selected?: false, disabled?: true },
      "e-gu" => %{selected?: false, disabled?: true }}

    assert options_matrix(shop.main_dishes, "monday") == %{
      "m-tb" => %{selected?: false, disabled?: true },
      "m-tm" => %{selected?: false, disabled?: true  },
      "m-ts" => %{selected?: true,  disabled?: false }}

    assert options_matrix(shop.desserts, "monday") == %{
      "d-fl" => %{selected?: false, disabled?: true},
      "d-gl" => %{selected?: true,  disabled?: false }}

    for day <- ["tuesday", "wednesday", "thursday", "friday"] do
      assert options_matrix(shop.entries, day) == %{
        "e-fr" => %{selected?: false, disabled?: false},
        "e-to" => %{selected?: false, disabled?: false},
        "e-gu" => %{selected?: false, disabled?: false}}

      assert options_matrix(shop.main_dishes, day) == %{
        "m-tb" => %{selected?: false, disabled?: false},
        "m-tm" => %{selected?: false, disabled?: false},
        "m-ts" => %{selected?: false, disabled?: false}}

      assert options_matrix(shop.desserts, day) == %{
        "d-fl" => %{selected?: false, disabled?: false},
        "d-gl" => %{selected?: false, disabled?: false}}
    end
  end

  def options_matrix(dishes, day) do
    Enum.map(dishes, fn(dish) ->
      {dish.id, options_for_day(dish, day)}
    end) |> Enum.into(%{})
  end

  def options_for_day(dish, day) do
    option = dish.day_options |> Enum.find(&(&1.value == day))
    %{selected?: option.selected?, disabled?: option.disabled?}
  end

  defp get(key, list) do
    list |> Enum.map(&(Map.get(&1, key)))
  end

  defp repo do
    MexiFoodRepoStub
  end

  defp show_shop(selection) do
    FoodShop.show_shop(selection: selection, repo: repo)
  end
end
