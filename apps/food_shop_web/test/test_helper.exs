ExUnit.start

Mix.Task.run "ecto.create", ~w(-r FoodShopWeb.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r FoodShopWeb.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(FoodShopWeb.Repo)

