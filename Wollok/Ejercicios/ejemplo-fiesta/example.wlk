//Para que no me joda los tests
object pepita {
  const energia = 100
  method energia(){ 
    return energia
  }
} 
///////////////////////////////


object manic {

  var cantidadDeEstrellas = 0

  method agarraEstrellas(){
    cantidadDeEstrellas += 8
  }

  method regalarEstrella(){
    if(cantidadDeEstrellas > 0){
      cantidadDeEstrellas -= 1
    }
  }
  
  method tieneTodoListo() = cantidadDeEstrellas >= 4

 }

object fiesta {

  var globos = 0
  var anfitrion = null

  method anfitrion(nuevoAnfi) {
    anfitrion = nuevoAnfi
  }

  method estaPreparada() = self.tieneSuficientesGlobos() and anfitrion.tieneTodoListo()
 
  method tieneSuficientesGlobos() = globos >= 50

  method sumarGlobos(nuevosGlobos) {
    globos += nuevosGlobos
  }

  method globos() = globos
}

object chuy {
  method tieneTodoListo() = true
}

/*
Hacer que Capy recolecte latas y las lleve a reciclar. Cuando las recolecta, lo hace 
de a una por vez. Cuando las lleva a reciclar lo hace por cinco a la vez. 
*/
object capy {
  var cantLatas = 0 

  method recolectar(){
     cantLatas += 1 
  }

  /*
  method reciclar(){
    if(cantLatas >= 5){ 
      cantLatas -= 5
    }
  } 
  */
  //Otra manera de hacerlo --> Si tiene menos de 5 recicla las que le quedan. 
  method reciclar() {
    cantLatas = 0.max(cantLatas - 5)
  }

  method tieneTodoListo() = cantLatas < 3
}