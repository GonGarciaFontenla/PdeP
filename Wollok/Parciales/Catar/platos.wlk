class Plato {
  var property cocinero

  method bonito()
  method azucar()
  
  method calorias() = 3 * self.azucar() + 100
}

class Entrada inherits Plato() {
  override method bonito() = true

  override method azucar() = 0
}

class Principal inherits Plato {
  const azucar 
  const bonito
  
  override method azucar() = azucar
  override method bonito() = bonito
}

class Postre inherits Plato() {
  var property cantColores

  override method azucar() = 120

  override method bonito() = cantColores > 3
}