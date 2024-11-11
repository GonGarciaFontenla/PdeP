object acmeSA {
  const personal = [] //en esta lista deberían guardarse TODOS los empleados de acmeSA, este objeto debería conocer mediante ella a cualquier otro objeto de clase empleado

  method personal() = personal

  method listaDeInvitados() = personal.filter({empleado => empleado.estaInvitado()})

  method cantidadDeInvitados() = self.listaDeInvitados().size()
}

class Empleado {
  const lenguajesConocidos = []

  method aprender(unLenguaje){
    lenguajesConocidos.add(unLenguaje)
  }

  method estaInvitado() = self.puedeSerInvitado() || self.esCopado()

  method puedeSerInvitado()

  method esCopado()

  method sabeUnLenguajeAntiguo() = lenguajesConocidos.any({lenguaje => lenguaje.esAntiguo()})

  method sabeUnLenguajeModerno() = lenguajesConocidos.any({lenguaje => lenguaje.esModerno()})

  method sabeWollok() = lenguajesConocidos.contains(wolok)

  method mesa() = self.lenguajesModernosConocidos().size()

  method lenguajesModernosConocidos() = lenguajesConocidos.filter({lenguaje => lenguaje.esModerno()})

  method regalo() = 1000 * self.lenguajesModernosConocidos().size()
}

class Jefe inherits Empleado {
  const empleadosACargo = []

  method tomarACargo(unEmpleado){
    empleadosACargo.add(unEmpleado)
  }

  override method puedeSerInvitado() = self.sabeUnLenguajeAntiguo() && self.soloTieneACargoGenteCopada()

  method soloTieneACargoGenteCopada() = empleadosACargo.all({empleado => empleado.esCopado()})

  override method esCopado() = false

  override method mesa() = 99

  override method regalo() = super() + empleadosACargo.size() * 1000
}

class Desarrollador inherits Empleado {
  override method esCopado() = self.sabeUnLenguajeAntiguo() && self.sabeUnLenguajeModerno()

  override method puedeSerInvitado() = self.sabeWollok() || self.sabeUnLenguajeAntiguo()
}

class Infraestructura inherits Empleado {
  var aniosExperiencia
  
  override method esCopado() = aniosExperiencia > 10

  override method puedeSerInvitado() = lenguajesConocidos.size() >= 5
}

class Lenguaje {
  const anioCreacion

  method esAntiguo() = anioCreacion > 2000

  method esModerno() = !self.esAntiguo()
}
object wolok inherits Lenguaje(anioCreacion = 2017){}

object fiesta {
  const costoFijoSalon = 200000
  const costoFijoXPersona = 5000
  const asistencias = []

  method recibirEmpleado(unEmpleado) {
    self.verificarInvitacion(unEmpleado)
    self.registrarAsistencia(unEmpleado)
  }

  method verificarInvitacion(unEmpleado) {
    if(!unEmpleado.estaInvitado()){throw new Exception(message = "el empleado no está invitado")}
  }
  
  method registrarAsistencia(unEmpleado) {
    asistencias.add(new Asistencia(empleado = unEmpleado, mesa = unEmpleado.mesa()))
  }

  method balance() = self.costoTotal() - self.regalosRecibidos()

  method costoTotal() = costoFijoSalon + costoFijoXPersona * self.cantidadDeAsistentes()

  method cantidadDeAsistentes() = asistencias.size()

  method regalosRecibidos() = asistencias.map({asistencia => asistencia.regalo()}).sum()

  method fueUnExito() = self.balancePositivo() && self.todosAsistieron()

  method balancePositivo() = self.balance() > 0

  method todosAsistieron() = self.cantidadDeAsistentes() == acmeSA.cantidadDeInvitados()

  method mesaConMasAsistentes() = self.mesas().max({mesa => self.mesas().ocurrencesOf(mesa)})

  method mesas() = asistencias.map({asistencia => asistencia.mesa()})
}

class Asistencia {
  const empleado
  const mesa

  method regalo() = empleado.regalo()

  method mesa() = mesa
}