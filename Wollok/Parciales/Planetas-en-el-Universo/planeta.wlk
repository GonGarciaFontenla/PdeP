import personas.*


class Planeta {
    var property habitantes = []
    var property construcciones = []
    var property delegacionDiplomatica = []

    method conformacionDelegacion() {
        habitantes.forEach({h => if(h.esDestacado() || self.mayorRecursos(h)) delegacionDiplomatica.add(h)})
    }

    //Otra forma
    method conformacionDelegacion2() {
        delegacionDiplomatica = habitantes.filter({h => h.esDestacado() || self.mayorRecursos(h)})
    }

    method mayorRecursos(h) {
        return not(habitantes.any({otherH => otherH.recursos() > h.recursos()}))
    }

    method esValioso() {
        return construcciones.sum({c => c.valor()}) > 100
    }
}