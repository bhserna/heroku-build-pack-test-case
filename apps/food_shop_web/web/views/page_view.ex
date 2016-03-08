defmodule FoodShopWeb.PageView do
  use FoodShopWeb.Web, :view

  def pluralize(count, singular, plural) do
    if count == 1, do: "#{count} #{singular}", else: "#{count} #{plural}"
  end
end
