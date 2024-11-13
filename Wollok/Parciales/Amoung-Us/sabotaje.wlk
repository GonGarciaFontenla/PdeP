import jugadores.*
import nave.*

object reducirOxigeno {
    method consecuencia() {
        if(!nave.tieneTuboOxigeno()){
            nave.bajarOxigieno(10)
        }
    }
}

object impugnarJugador{
    method consecuencia(jugador) {
        jugador.impugnarVoto()
    }
}