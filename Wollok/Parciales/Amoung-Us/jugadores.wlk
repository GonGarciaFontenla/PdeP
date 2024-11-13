import nave.*
import tareas.*

class Jugadores {
//   const color
  const tareas = []
  const mochila = []
  var estaVivo = true
  var puedeVotar = true
  var sospecha = 40

  method sospechoso() = sospecha > 50

  method buscarItem(item) {mochila.add(item)}
  method tieneItem(item) = mochila.contains(item)
  method usarItem(item) {mochila.remove(item)}

  method aumentarSospecha(valor) {sospecha += valor} 
  method disminuirSospecha(valor) {sospecha -= valor}

  method realizoSusTareas() = tareas.size() == 0 
  
  method realizarTarea(tarea) {
    tarea.realizate(self)
    tareas.remove(tarea)
    nave.todasLasTareasCompletadas()
  }

  method impugnarVoto() {
    puedeVotar = false
  }

  method llamarReunionDeEmergencia() {
    nave.llamarReunionDeEmergencia()
  }

  method estaVivo() = estaVivo
}

class Tripulantes inherits Jugadores {


}

class Impostores inherits Jugadores {
    override method realizoSusTareas() = true

    override method realizarTarea(tarea) {}
}