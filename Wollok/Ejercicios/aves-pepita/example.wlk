object pepita {
    var energia = 100
    method volar(kilometros){
        energia = energia - 40 - 5 * kilometros
    }
    method comer(gramos){
        energia = energia + 2 * gramos
    }
    method energia(){ 
        return energia
    }
}

object josefa {
  var gramosComidos = 0 
  var kilometrosVolados = 0
  const energiaInicial = 80

  method comer(gramos){
    gramosComidos = gramosComidos + gramos
  }
  method volar(kilometros){ 
    kilometrosVolados = kilometrosVolados + kilometros
  }
  method energia(){
    return energiaInicial + 5 * gramosComidos - 3 * kilometrosVolados
  }
}

