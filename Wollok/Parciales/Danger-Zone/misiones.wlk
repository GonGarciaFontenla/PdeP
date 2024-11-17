class Mision {
  var property habilidadRequeridas
  var peligrosidad

  var tipoMision

  method puedeCumplirMision() = tipoMision.puedeCumplirMision()

  method cumplirMision() {
    if(self.puedeCumplirMision()) {
      tipoMision.hacerDanio(self)
      tipoMision.recompensaMision()
    }
  }

  method contieneTodasHabilidades(participante) = habilidadRequeridas.all({h => participante.tieneHabilidad(h)}) 
}

class MisionPorEquipos {
  var equipo 

  method puedeCumplirMision(mision) = self.algunoPoseeHabilidad(mision)

  method algunoPoseeHabilidad(mision) = mision.habilidadRequeridas().all({h => equipo.any({m => m.tieneHabilidad(h)})})

  method hacerDanio(mision) = equipo.forEach({m => m.quitarSalud(mision.peligrosidad())})

  method recompensaMision(mision) = equipo.forEach({m => m.completarMision(mision)})
}

class MisionIndividual {
  var participante 

  method puedeCumplirMision(mision) = mision.contieneTodasHabilidades(participante)

  method hacerDanio(mision) = participante.quitarSalud(mision.peligrosidad())

  method recompensaMision(mision) = participante.completarMision(mision)
}