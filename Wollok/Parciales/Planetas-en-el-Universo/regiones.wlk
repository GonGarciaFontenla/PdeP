import construcciones.*
import personas.*
import planeta.*
class Region {
    method addConstruccion(planeta, construct, construccion) {
        planeta.construcciones().add(construccion)
        construct.construccionesRealizadas().add(construccion)
    }
}
object montania inherits Region{
    method construccionDeRegion(construct, planeta, time) {
        const muralla = new Muralla(longitud = time / 2)
        self.addConstruccion(planeta, construct, muralla)
    }
} 

object costa inherits Region{
    method construccionDeRegion(construct, planeta, time) {
        const museo = new Museo(superficie = time, importancia = 1)
        self.addConstruccion(planeta, construct, museo)
    }
}

object llanura inherits Region{ 
    var construccion = null

    method construccionDeRegion(construct, planeta, time) {
        self.tipoConstruccion(construct, time)
        self.addConstruccion(planeta, construct, construccion) 
    }

    method tipoConstruccion(construct, time) {
        if(construct.esDestacado()) {
            const museo = new Museo(superficie = time, importancia = Number.randomUpTo(5))
            construccion = museo
        }else {
            const muralla = new Muralla(longitud = time)
        }
    }
}