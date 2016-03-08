defmodule FoodShopWeb.PageController do
  use FoodShopWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
