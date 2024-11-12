import casas.*

class UserException inherits wollok.lang.Exception {}

class Bot {
  var property cargaElectrica
  var property estadoAceite = aceite.puro()
  const aceite = new Aceite(puro = true)

  method disminuirCarga(valor) {
    cargaElectrica -= valor
  }

  method aumentarCarga(valor) {
    cargaElectrica += valor
  }

  method puedeIrAHogwarts() = false

  method cambiarPureza() {
    aceite.hacerImpuro() 
      estadoAceite = aceite.puro()
    }
}

object sombrero inherits Bot(cargaElectrica = 0, estadoAceite = true){
  const casasPosibles = [gryffindor, slytherin, ravenclaw, hufflepuff]
  var houseIndex = 0

  method asignarCasa(estudiante) {
    if(houseIndex < casasPosibles.size() - 1){
      estudiante.casa(casasPosibles.get(houseIndex)) 
      houseIndex += 1
    }else {houseIndex = 0}
  }

  override method cambiarPureza() {estadoAceite = true} 
}


//Podria llegar a crear un nuevo archivo, per como es poco lo dejo asi y listo. 
class Aceite {
  var property puro

  method hacerImpuro() {
    puro = false
  } 
}