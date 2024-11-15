import empleaados.*

object fiesta {
    const costoFijo = 200000
    var property asistieron = []

    method costoTotal() = asistieron.size() * 5000 + costoFijo

    method recibirInvitado(invitado) {
        self.verificarInvitaciones(invitado)
        self.registrarAsistencia(invitado)
    }

    method balanceTotal() = -1 * self.costoTotal() + self.recaudacionRegalos()

    method verificarInvitaciones(invitado) { if(!invitado.estaInvitado()) throw new DomainException(message = "El empleado no esta invitado") }

    method registrarAsistencia(_empleado) {
        asistieron.add(new Asistencia(mesa = _empleado.mesa(), empleado = _empleado))
    }

    method recaudacionRegalos() = asistieron.sum({e => e.regalo()})

    method fiestaExitosa() = self.balanceTotal() > 0 and self.asistieronTodos() 

    method asistieronTodos() = self.asistieron().size() == acmeSA.cantidadDeInvitados()


  method mesaConMasAsistentes() = self.mesas().max({mesa => self.mesas().ocurrencesOf(mesa)})

  method mesas() = asistieron.map({asistencia => asistencia.mesa()})
}

class Asistencia {
    var mesa
    var empleado

    method mesa() = mesa
    method regalo() = empleado.regalo()
}