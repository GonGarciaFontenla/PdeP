import juegos.*

object steam {
  var juegosDisponibles = []

  method cambiarDescuento(juego, nuevoDescuento) {
    juego.descuento(nuevoDescuento)
  }

  method manejarDescuentos(juego, descuento) {
    if(descuento > 1) { throw new Exception (message = "El descuento no puede ser mayor al 100%") }

    const descuentoAaplicar = new DescuentoDirecto(porcentaje = descuento)
    self.aplicarDescuentoCadaJuego(descuentoAaplicar)
  }

  method juegoMasCaro() = juegosDisponibles.max({j => j.precio()})

  method superanTresCuartos() = juegosDisponibles.filter({j => j.precio() > self.juegoMasCaro().precio() * 0.75})

  method aplicarDescuentoCadaJuego(_descuento) = self.superanTresCuartos().forEach({j => self.cambiarDescuento(j, _descuento)})

}