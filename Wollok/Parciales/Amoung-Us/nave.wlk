import jugadores.*

class UserException inherits wollok.lang.Exception {}


object nave {
    const jugadores = []
    var impostores = 0
    var tripulantes = 0

    var oxigeno = 0

    method aumentarOxigeno(valor) {oxigeno += valor}
    method bajarOxigieno(valor) {oxigeno -= valor}

    method todasLasTareasCompletadas() {
        if(jugadores.all({t => t.realizoSusTareas()})){
            throw new UserException(message = "Ganaron los tripulantes!!!!!")
        }
    }

    method tieneTuboOxigeno() = jugadores.any({j => j.mochila().contains("tubo de oxigeno")})
    
}