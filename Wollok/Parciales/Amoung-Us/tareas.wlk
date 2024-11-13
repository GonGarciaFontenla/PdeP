import jugadores.*
import nave.* 

class Tarea {
    const requiredItems = []

    method puedeRealizarTarea(jugador) = requiredItems.all({i => jugador.tieneItem(i)})

    method realizate(jugador) {
        self.afectarA(jugador) 
        self.eliminarItems(jugador)
    }

    method eliminarItems(jugador) {
        requiredItems.forEach({i => jugador.usarItem(i)})
    } 

    method afectarA(jugador)
}

object arreglarTablero inherits Tarea (requiredItems = ["llaveInglesa"]){ 
    override method afectarA(jugador) {
        jugador.aumentarSospecha(10)
    }
}

object sacarBasura inherits Tarea (requiredItems = ["escoba", "bolsa de consorcio"]) {
    override method afectarA(jugador) {
        jugador.disminuirSospecha(4)
    }
}

object ventilarNave inherits Tarea {
    override method afectarA(jugador) {
        nave.aumentarOxigeno(5)
    }
}