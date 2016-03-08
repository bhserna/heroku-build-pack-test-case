ExUnit.start()

defmodule MexiFoodRepoStub do
  @dishes [
    %{id: "e-fr",
      name: "Frijolitos",
      description: "Frijoles a la charra muy ricos",
      image_url: "/frijolitos.png",
      category: "entry"},
    %{id: "e-to",
      name: "Totopos",
      description: "Tortillitas fritas con frijoles refritos",
      image_url: "/totopos.png",
      category: "entry"},
    %{id: "e-gu",
      name: "Guacamole",
      description: "Aguacata molido y tortillas",
      image_url: "/guacamole.png",
      category: "entry"},

    %{id: "m-tb",
      name: "Tacos de bistec",
      description: "5 tradicionales tacos de bistec",
      image_url: "/bistec.png",
      category: "main"},
    %{id: "m-ts",
      name: "Tacos de sirlon",
      description: "5 tradicionales tacos de sirlon",
      image_url: "/sirlon.png",
      category: "main"},
    %{id: "m-tm",
      name: "Tacos de molleja",
      image_url: "/molleja.png",
      description: "5 tradicionales tacos de molleja",
      category: "main"},

    %{id: "d-fl",
      name: "Flan",
      description: "El flan de la abuela",
      image_url: "/flan.png",
      category: "dessert"},
    %{id: "d-gl",
      name: "Glorias",
      description: "Tres glorias",
      image_url: "/glorias.png",
      category: "dessert"},
  ]

  def all do
    @dishes
  end
end
