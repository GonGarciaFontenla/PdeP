import tecnicas.*

class Persona{
  var property recursos = cantMonedas
  var property cantMonedas = 20
  var property edad = 0

  method ganarMonedas(coins){
    recursos += coins
  }

  method gastarMonedas(coins) {
    recursos -= coins
  }

  method cumplirAnios() {
    edad += 1
  }

  method esDestacado() {
    return self.condDestacado()
  }

  method condDestacado() {
    return edad >= 18 and edad <=65 || recursos > 30
  }
}

class Productor inherits Persona{
  var property tecnicas = []
  
  method cantRecursos() {
    recursos = cantMonedas * tecnicas.size()
  }

  override method esDestacado() {
    return self.condDestacado() || tecnicas.size() > 5
  }

  method realizarTecnica(tecnica, tiempo) {
    if(tecnicas.contains(tecnica)){
      recursos += tiempo * 3
    }else {
      recursos -= 1
    }
  }

  method aprenderTecnica(tecnica) {
    tecnicas.add(tecnica)
  }

  method trabajarEnPlaneta(planeta, time) {
    if(planeta.habitantes().contains(self)){
      self.realizarTecnica(tecnicas.last(), time)
    }
  }
}

class Constructor inherits Persona{
  var property construccionesRealizadas = []
  var regionVive
  method cantRecursos() {
    recursos = cantMonedas * construccionesRealizadas.size()
  }

  override method esDestacado() {
    return construccionesRealizadas.size() > 5
  }

  method construir(planeta, tiempo) {
    planeta.construcciones().add(regionVive.construccionDeRegion(self, planeta, tiempo)) 
    cantMonedas -= 5
  }
}