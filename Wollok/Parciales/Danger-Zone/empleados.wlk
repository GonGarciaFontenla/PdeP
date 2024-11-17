class Empleado {
  var habilidades
  var salud
  var property puesto 

  method salud() = salud
  method saludCritica()

  method incapacitado() = salud < puesto.saludCritica()

  method puedeUsarHabilidad(habilidad) = !self.incapacitado() and self.tieneHabilidad(habilidad)
  
  method tieneHabilidad(habilidad) = habilidades.contains(habilidad)

  method quitarSalud(cantidad) { salud -= cantidad }

  method completarMision(mision) = puesto.recompensaMision(mision, self)
}

class Jefe inherits Empleado{
  var empleadosAcargo 

  override method tieneHabilidad(habilidad) = super(habilidad) || empleadosAcargo.any({e => e.tieneHabilidad(habilidad)}) 
}

object espia{
  method saludCritica() = 15

  method recompensaMision(mision, empleado) { self.agregarHabilidadesDesconocidas(empleado.habilidades(), mision.habilidadRequeridas()) }

  method agregarHabilidadesDesconocidas(habilidadesE, habilidadesM) { habilidadesM.forEach({h => if(!habilidadesE.contains(h)) habilidadesE.add(h)}) }
}

class Oficinista{
  var estrellas 

  method sumarEstrella() { estrellas += 1 }

  method saludCritica() = 40 - 5 * estrellas 

  method recompensaMision(mision, empleado) { 
    self.sumarEstrella()
    if(estrellas > 3) {
      empleado.puesto(espia)
    }
    }
}