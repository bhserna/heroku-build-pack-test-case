defmodule FoodShopTest do
  use ExUnit.Case
  doctest FoodShop

  test "show all dishes by category" do
    shop = show_shop(repo)

    assert get(shop.entries, :name) == [
      "Frijolitos", "Totopos", "Guacamole"]

    assert get(shop.main_dishes, :name) == [
      "Tacos de bistec", "Tacos de sirlon", "Tacos de molleja"]

    assert get(shop.desserts, :name) == [
      "Flan", "Glorias"]
  end

  test "shows description" do
    shop = show_shop(repo)

    assert get(shop.entries, :description) == [
      "Frijoles a la charra muy ricos",
      "Tortillitas fritas con frijoles refritos",
      "Aguacata molido y tortillas"
    ]

    assert get(shop.main_dishes, :description) == [
      "5 tradicionales tacos de bistec",
      "5 tradicionales tacos de sirlon",
      "5 tradicionales tacos de molleja"
    ]

    assert get(shop.desserts, :description) == [
      "El flan de la abuela",
      "Tres glorias"
    ]
  end

  test "shows image" do
    shop = show_shop(repo)

    assert get(shop.entries, :image_url) == [
      "/frijolitos.png",
      "/totopos.png",
      "/guacamole.png"
    ]

    assert get(shop.main_dishes, :image_url) == [
      "/bistec.png",
      "/sirlon.png",
      "/molleja.png"
    ]

    assert get(shop.desserts, :image_url) == [
      "/flan.png",
      "/glorias.png"
    ]
  end

  test "each dish has its own id" do
    shop = show_shop(repo)
    assert get(shop.entries, :id) == ["e-fr", "e-to", "e-gu"]
    assert get(shop.main_dishes, :id) == ["m-tb", "m-ts", "m-tm"]
    assert get(shop.desserts, :id) == ["d-fl", "d-gl"]
  end

  test "shows the available days to select from" do
    shop = show_shop(repo)

    shop.entries ++ shop.main_dishes ++ shop.desserts
    |> get(:day_options)
    |> Enum.all? fn(day_options) ->

      assert get(day_options, :value) == [
        "monday", "tuesday", "wednesday", "thursday", "friday"]

      assert get(day_options, :text) == [
        "Lunes", "Martes", "Miercoles", "Jueves", "Viernes"]
    end
  end


  defp get(list, key) do
    list |> Enum.map(&(Map.get(&1, key)))
  end

  defp repo do
    MexiFoodRepoStub
  end

  defp show_shop(repo) do
    FoodShop.show_shop(repo: repo)
  end
end
