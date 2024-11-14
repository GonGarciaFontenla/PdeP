import miguelito.*

class Comensal {
    var dinero
    var condicion

    method dinero() = dinero

    method darGusto() { //dejo esto para terminar.
        if(self.puedeComprar().isEmpty()) throw new DomainException(message = "No hay platos para comprar")
        else self.comprar(self.platoPremium())
    }

    method comprar(plato){
        dinero -= plato.precio()
        miguelito.vender(plato, self)
    }

    method puedeComprar() = miguelito.platosAccesibles(dinero).filter({p => condicion.leAgrada(p)})

    method platoPremium() = self.puedeComprar().max({p => p.valoracion()})

    method aceptarPromocion(dineroPromo) {dinero += dineroPromo}

    method cambiarHabitos(newHabito) { condicion = newHabito } 

    method problemasGastriticos() { self.cambiarHabitos(celiaco) }
}

object celiaco {
    method leAgrada(plato) = plato.aptoCeliaco()
    method puedeCambiarTodoTerreno() = true
}

object paladarFino {
    method leAgrada(plato) = plato.especial() || plato.valoracion() > 100
    method puedeCambiarTodoTerreno() = true
}

object todoTerreno {
    method leAgrada(plato) = true
    method puedeCambiarTodoTerreno() = false
}

object gobierno {
    var ciudadanos = []

    method tomarDecisonEconomica() { self.ciudadanosAptosCambio().cambiarHabito(todoTerreno) }

    method ciudadanosAptosCambio() = ciudadanos.filter({c => c.puedeCambiarTodoTerreno()})
}