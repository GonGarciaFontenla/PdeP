import comensales.*

object miguelito {
    const platoOfrecidos = []
    const comensalesCotidianos = []
    var ingresos = 0

    method promocion(dinero) { comensalesCotidianos.forEach({c => c.aceptarPromocion(dinero)}) }

    method aumentarIngresos(dinero) { ingresos += dinero }

    method vender(plato, comensal) {
        ingresos += plato.precio()
        comensalesCotidianos.add(comensal)
    }

    method platosAccesibles(dinero) = platoOfrecidos.filter({p => p.precio() <= dinero})

    method agregarPlatoAlMenu(hamburguesa) {
        platoOfrecidos.add(hamburguesa)
    }
}