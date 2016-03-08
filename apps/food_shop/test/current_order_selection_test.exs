defmodule CurrentOrderSelectionTest do
  use ExUnit.Case
  doctest FoodShop

  test "select entry for monday" do
    selection = %{"e-fr" => %{ "monday" => "1" }}
    order = current_order(selection)
    [monday] = order.selection

    assert monday.day_name == "Lunes"
    assert monday.dishes == "Frijolitos"

    refute order.confirmed?
    refute order.selection_blocked?
    refute order.has_controls?
    refute order.has_total_message?
    refute order.has_confirm_order_button?
    assert order.complete_selected_days == 0
    assert order.package_to_charge == ""
    assert order.package_to_charge_price == ""

    # current view
    assert order.showing_dish_selection?
    refute order.asking_user_info?
    refute order.asking_shipping_address?
  end

  test "select entries for monday and tuesday" do
    selection = %{"e-fr" => %{ "monday" => "1" }, "e-gu" => %{ "tuesday" => "1" }}
    order = current_order(selection)
    [monday, tuesday] = order.selection

    assert monday.day_name == "Lunes"
    assert monday.dishes == "Frijolitos"

    assert tuesday.day_name == "Martes"
    assert tuesday.dishes == "Guacamole"

    refute order.confirmed?
    refute order.selection_blocked?
    refute order.has_controls?
    refute order.has_total_message?
    refute order.has_confirm_order_button?
    assert order.complete_selected_days == 0
    assert order.package_to_charge == ""
    assert order.package_to_charge_price == ""

    # current view
    assert order.showing_dish_selection?
    refute order.asking_user_info?
    refute order.asking_shipping_address?
  end

  test "select for monday (just entry and main dish)" do
    selection = %{"e-fr" => %{ "monday" => "1" }, "m-tb" => %{ "monday" => "1" }}
    order = current_order(selection)
    [monday] = order.selection

    assert monday.day_name == "Lunes"
    assert monday.dishes == "Frijolitos, Tacos de bistec"

    refute order.confirmed?
    refute order.selection_blocked?
    refute order.has_controls?
    refute order.has_total_message?
    refute order.has_confirm_order_button?
    assert order.complete_selected_days == 0
    assert order.package_to_charge == ""
    assert order.package_to_charge_price == ""

    # current view
    assert order.showing_dish_selection?
    refute order.asking_user_info?
    refute order.asking_shipping_address?
  end

  test "select for monday" do
    selection = %{"e-fr" => %{ "monday" => "1" }, "m-tb" => %{ "monday" => "1" }, "d-fl" => %{ "monday" => "1" }}
    order = current_order(selection)
    [monday] = order.selection

    assert monday.day_name == "Lunes"
    assert monday.dishes == "Frijolitos, Tacos de bistec, Flan"

    refute order.confirmed?
    refute order.selection_blocked?
    assert order.has_total_message?
    assert order.has_confirm_order_button?
    assert order.complete_selected_days == 1
    assert order.package_to_charge == "Paquete de 1 día"
    assert order.package_to_charge_price == "89"

    # current view
    assert order.showing_dish_selection?
    refute order.asking_user_info?
    refute order.asking_shipping_address?
  end

  test "select for two days" do
    selection = %{
      "e-fr" => %{
        "monday" => "1",
        "friday" => "1" },
      "m-tb" => %{
        "monday" => "1",
        "friday" => "1" },
      "d-fl" => %{
        "monday" => "1",
        "friday" => "1" }}

    order = current_order(selection)
    [monday, friday] = order.selection

    assert monday.day_name == "Lunes"
    assert monday.dishes == "Frijolitos, Tacos de bistec, Flan"
    assert friday.day_name == "Viernes"
    assert friday.dishes == "Frijolitos, Tacos de bistec, Flan"

    refute order.confirmed?
    refute order.selection_blocked?
    refute order.has_controls?
    refute order.has_total_message?
    refute order.has_confirm_order_button?
    assert order.complete_selected_days == 2
    assert order.package_to_charge == ""
    assert order.package_to_charge_price == ""

    # current view
    assert order.showing_dish_selection?
    refute order.asking_user_info?
    refute order.asking_shipping_address?
  end

  test "confirm order" do
    selection = %{"e-fr" => %{ "monday" => "1" }, "m-tb" => %{ "monday" => "1" }, "d-fl" => %{ "monday" => "1" }}
    confirmed = true
    order = current_order(selection, confirmed)

    assert order.confirmed?
    assert order.selection_blocked?

    # current view
    refute order.showing_dish_selection?
    assert order.asking_user_info?
    refute order.asking_shipping_address?
  end

  test "ask user info" do
    selection = %{"e-fr" => %{ "monday" => "1" }, "m-tb" => %{ "monday" => "1" }, "d-fl" => %{ "monday" => "1" }}
    confirmed = true
    user_info = %{"name" => "Benito", "email" => "bhserna@innku.com", "phone_number" => "12341234"}
    order = current_order(selection, confirmed, user_info)

    assert order.confirmed?
    assert order.selection_blocked?

    # current view
    refute order.showing_dish_selection?
    refute order.asking_user_info?
    assert order.asking_shipping_address?
  end

  defp repo do
    MexiFoodRepoStub
  end

  def current_order(selection) do
    FoodShop.
    show_shop(selection: selection, repo: repo).
    current_order
  end

  def current_order(selection, confirmed) do
    FoodShop.
    show_shop(selection: selection, repo: repo, order_confirmed: confirmed).
    current_order
  end

  def current_order(selection, confirmed, user_info) do
    FoodShop.
    show_shop(selection: selection, repo: repo, order_confirmed: confirmed, user_info: user_info).
    current_order
  end
end
