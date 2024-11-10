//villano
class Villano {
  const ejercitoDeMinions
  //const maldades
  const ciudadEnLaQueVive

  method nuevoMinion() {
    ejercitoDeMinions.add(new Minion(bananas = 5, armas = (new Arma(nombre ="rayoCongelante", potencia = 10))))
  }

  method planificarMaldad(maldad) {
    maldad.realizarse(ejercitoDeMinions, ciudadEnLaQueVive)
  }

  //estadisticas
  method minionMasUtil() = ejercitoDeMinions.max({minion => minion.maldadesRealizadas()})

  method minionsInutiles() = ejercitoDeMinions.filter({minion => minion.maldadesRealizadas() == 0})
}

//minions
class Minion {
  var bananas
  var armas = []
  var estado = amarillo
  var maldadesRealizadas = 0

  method esPeligroso() = estado.esPeligroso(self)

  method cantidadDeArmas() = armas.size()

  method otorgarArma(unArma) {
    armas.add(unArma)
  }

  method alimentar(cantidad) {
    bananas += cantidad
  }

  method nivelDeConcentracion() = estado.nivelDeConcentracion(self)

  method bananas() = bananas

  method mayorPotencia() = armas.max({arma => arma.potencia()})

  method tomarSueroMutante() {
    estado.tomarSueroMutante(self)
  }

  method perderArmas() {
    armas = []
  }

  method perderBananas(cantidad) {
    bananas -= cantidad
  }

  method alocarse() {
    estado = violeta
  }

  method tranquilizarse() {
    estado = amarillo
  }

  method tieneArma(nombreArma) = armas.any({arma => arma.nombre() == nombreArma})

  method estaConcentrado(concentracionNecesaria) {
    self.nivelDeConcentracion() >= concentracionNecesaria
  }

  method maldadesRealizadas() = maldadesRealizadas

  method contabilizarMaldad() {
    maldadesRealizadas += 1
  }
}

object amarillo {
  method esPeligroso(minion) = minion.cantidadDeArmas() > 2

  method nivelDeConcentracion(minion) = minion.mayorPotencia() + minion.bananas()

  method tomarSueroMutante(minion) {
    minion.perderArmas()
    minion.perderBananas(1)
    minion.alocarse()
  }
}

object violeta {
  method esPeligroso(minion) = true

  method nivelDeConcentracion(minion) = minion.bananas()

  method tomarSueroMutante(minion) {
    minion.perderBananas(1)
    minion.tranquilizarse()
  }
}

//armas
class Arma {
  const nombre
  const potencia

  method potencia() = potencia

  method nombre() = nombre
}

//ciudades
class Ciudad {
  var temperatura
  const posesiones

  method disminuirTemperatura(cantidad) {
    temperatura -= cantidad
  }

  method robar(algo) {
    posesiones.remove(algo)
  }
}

//maldades
class Maldad {
  const requerimientoAdicional
  const premio
  const concentracionNecesaria

  method minionsCapacitados(ejercito) = ejercito.filter({minion => requerimientoAdicional.estaCapacitado(minion) && minion.estaConcentrado(concentracionNecesaria)})

  method realizarse(ejercito, ciudad) {
    if (self.minionsCapacitados(ejercito).isEmpty()) {throw new Exception(message = "error, la maldad no puede realizarse")}
    premio.premiar(self.minionsCapacitados(ejercito))
  }
}

object congelar inherits Maldad(requerimientoAdicional = requerimientoCongelar, premio = premio10Bananas, concentracionNecesaria = 500){
  override method realizarse(ejercito, ciudad) {
    super(ejercito, ciudad)
    ciudad.disminuirTemperatura(30)
  }
}

class Robo inherits Maldad(){
  const objetivoRobo

  override method minionsCapacitados(ejercito) = ejercito.filter({minion => requerimientoAdicional.estaCapacitado(minion) && minion.estaConcentrado(concentracionNecesaria) && minion.esPeligroso()})
  
  override method realizarse(ejercito, ciudad) {
    super(ejercito, ciudad)
    ciudad.robar(objetivoRobo)
  }
}

class RobarPiramide inherits Robo(requerimientoAdicional = requerimientoNulo, concentracionNecesaria = objetivoRobo.altura()/2, premio = premio10Bananas){}

object robarSuero inherits Robo(requerimientoAdicional = requerimientoBuenaAlimentacion, premio = premioSuero, concentracionNecesaria = 23, objetivoRobo = sueroMutante){}

object robarLuna inherits Robo(objetivoRobo = luna, requerimientoAdicional = requerimientoEncoger, concentracionNecesaria = 0, premio = premioCongelar) {
  
}

//requerimientos
class RequerimientoArma {
  const armaNecesaria

  method estaCapacitado(minion) = minion.tieneArma(armaNecesaria)
}

object requerimientoCongelar inherits RequerimientoArma(armaNecesaria = "rayoCongelante") {}

object requerimientoEncoger inherits RequerimientoArma(armaNecesaria = "rayoEncogedor") {}

object requerimientoPeligrosidad {
  method estaCapacitado(minion) = minion.esPeligroso()
}

object requerimientoNulo {
  method estaCapacitado(minion) = true
}

object requerimientoBuenaAlimentacion {
  method estaCapacitado(minion) = minion.bananas() >= 100
}

//premios
//quizá se podría agregar una abstracción mas como una clase premio que haga el foreach y aumente en 1 las maldades realizadas
object premio10Bananas {
  method premiar(minions) {
    minions.forEach({minion => minion.alimentar(10) minion.contabilizarMaldad()})
  }
}

object premioSuero {
  method premiar(minions) {
    minions.forEach({minion => minion.tomarSueroMutante() minion.contabilizarMaldad()})
  }
}

class PremioArma {
  const arma

  method premiar(minions) {
    minions.forEach({minion => minion.otorgarArma(arma) minion.contabilizarMaldad()})
  }
}

object premioCongelar inherits PremioArma(arma = new Arma(nombre = "rayoCongelante", potencia = 10)) {}

//objetivos
class Piramide {
  const altura

  method altura() = altura
}

object sueroMutante{} //para que sea el objetivo del robo del suero

object luna{} //idem anterior

/*
Punto 4
a) Esto es simple, solo habria que agregar otro objeto para el estado verde del minion y definir su comportamiento, además de modificar oportunamente el comportamiento de los otros estados 
para cumplir con el nuevo requerimiento
b) Más fácil aún, en este caso bastaría con modificar el método de tomarSueroMutante en el estado violeta para que este ya no modifique el estado del minion, en este caso quitando la 
llamada al metodo tranquilizarse
*/