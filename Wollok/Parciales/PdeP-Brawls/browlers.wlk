class Personaje {
  var copas

  method estrategia()
  method destreza()

  method darCopas(_copas) { copas += _copas }
  method copas() = copas
}

class Arquero inherits Personaje {
  var agilidad 
  var rango 

  override method destreza() = agilidad * rango
  override method estrategia() = rango > 100
}

class Guerrera inherits Personaje {
  var estrategia
  var fuerza

  override method estrategia() = estrategia

  override method destreza() = fuerza * 1.50
}

class Ballestero inherits Arquero {
  override method destreza() = super() * 2
}