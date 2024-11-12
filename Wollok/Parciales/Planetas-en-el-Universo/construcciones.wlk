class Muralla {
    var longitud
    const precioMedida = 10

    method valor() {
        return longitud * precioMedida
    }
}

class Museo { 
    var superficie 
    var importancia
    
    method importancia(_importancia) {
        importancia = _importancia.min(5).max(1)
    }

    method valor(){
        return superficie * importancia
    }
}