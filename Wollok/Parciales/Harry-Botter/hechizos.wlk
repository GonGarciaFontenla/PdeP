import casas.*
import bots.*
import hechizeros.*
class Hechizo {
    const cargaArestar = 0

    method consecuencias(victima) {
        victima.disminuirCarga(cargaArestar)
    }
    method requerimientos(mago) = mago.cargaElectrica() > cargaArestar
}

object inmobilus inherits Hechizo(cargaArestar = 50){
    override method requerimientos(mago) = true
}

object sectumSempra inherits Hechizo{
    override method consecuencias(victima) {
        victima.cambiarPureza()
    }

    override method requerimientos(mago) = mago.esExperimentado() 
}

object avadakedabra inherits Hechizo{
    override method consecuencias(victima){
        victima.cargaElectrica(0)
    }

    override method requerimientos(mago) = mago.estadoAceite() ||  mago.casa().esPeligrosa2()
}

object espectroPatronus inherits Hechizo{ //Hechizo regenerador
    override method consecuencias(victima) {
        victima.aumentarCarga(20)
    }
    override method requerimientos(mago) = true
}

const hechizoNormal = new Hechizo(cargaArestar = 40)