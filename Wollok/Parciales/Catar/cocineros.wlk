import platos.*
import torneo.*

class Cocinero {
    var especialidad
    
    method catar(plato) = especialidad.catar(plato)

    method cambiarEspecialidad(espe) {
        especialidad = espe
    }

    method cocinar() {
        especialidad.cocinar()
    } 

    method participarTorneo() {
        Torneo.platosParticipantes.add(especialidad.cocinar())
    }
}

class Pastelero {
    var nivelAzucar

    method catar(plato) = (5 * plato.azucar() / nivelAzucar).min(10)

    method cocinar(_cocinero) = new Postre(cocinero = _cocinero, cantColores = nivelAzucar/50 )
}

class Chef {
    var caloriasMax

    method catar(plato) {
        if(self.bonitoYflaquito(plato)) 10
        else 0
    }

    method bonitoYflaquito(plato) = plato.bonito() and plato.calorias() < caloriasMax

    method cocinar(_cocinero) = new Principal(cocinero = _cocinero, azucar = caloriasMax, bonito = true)
}

class Souschef inherits Chef {
    override method catar(plato) {  
        if(self.bonitoYflaquito(plato)) plato.calificacion(10)
        else plato.calificacion((plato.calorias() / 100).min(6))
    }

    override method cocinar(_cocinero) = new Entrada(cocinero = _cocinero)
}