
class Pais {
  var monedaLocal
  var legislacion

  method monedaLocal() = monedaLocal
  
  method esAptoMenores(juego) = !self.contieneCaractNoPermitida(juego)

  method contieneCaractNoPermitida(juego) = juego.caracteristicas().any({c => legislacion.contains(c)})
}