object acmeSA {
  const personal = [] //en esta lista deberían guardarse TODOS los empleados de acmeSA, este objeto debería conocer mediante ella a cualquier otro objeto de clase empleado

  method personal() = personal

  method listaDeInvitados() = personal.filter({empleado => empleado.estaInvitado()})

  method cantidadDeInvitados() = self.listaDeInvitados().size()
}


class Empleado {
  var lenguajes

  method sabeLenguajeAntiguo() = lenguajes.any({l => l.esAntiguo()})

  method estaInvitado() = self.esCopado()
  method esCopado()

  method asignarNuevoJefe(jefe, empleado) { jefe.empleadosAcargo().add(empleado) }

  method mesa() = self.cantidadLenguajes()

  method cantidadLenguajes() = lenguajes.size()

  method regalo() = self.cantidadLenguajes() * 1000
}

class Desarrollador inherits Empleado{
  override method estaInvitado() = super() || lenguajes.contains("wollok") || self.sabeLenguajeAntiguo()

  override method esCopado() = self.sabeLenguajeAntiguo() and self.sabeLenguajeModerno()

  method sabeLenguajeModerno() = lenguajes.any({l => l.esModerno()})
}

class Infraestructura inherits Empleado{
  var aniosExperencia 

  override method estaInvitado() = super() || self.cantidadLenguajes() > 5 

  override method esCopado() = aniosExperencia > 10
}

class Jefe inherits Empleado{
  var property empleadosAcargo

  override method estaInvitado() = super() || self.sabeLenguajeAntiguo() and self.aCargoCopados()

  method aCargoCopados() = empleadosAcargo.all({e => e.esCopado()})

  override method regalo() = super() + 1000 * self.cantidadEmpleados()

  method cantidadEmpleados() = empleadosAcargo.size()

  override method mesa() = 99
}

class Lenguaje {
  const anioCreacion

  method esAntiguo() = anioCreacion < 2000
  method esModerno() = anioCreacion >= 2000
}

