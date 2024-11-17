class Chat {
    const participantes
    const property mensajes

    method espacio() = mensajes.sum({m => m.peso()})

    method enviarMensaje(mensaje) {
        self.validarMensaje(mensaje)
        mensajes.add(mensaje)
        self.enviarNotificacion()
    }

    method validarMensaje(mensaje) = if(!self.puedeEnviarMensaje(mensaje)) throw new DomainException (message = "No se puede enviar el mensaje")

    method puedeEnviarMensaje(mensaje) = participantes.contains(mensaje.emisor()) and participantes.all({p => p.tieneEspacioSuficiente(mensaje)})

    method contiene(subMensaje) = mensajes.any({m => m.contains(subMensaje)})

    method mensajeMasPesado() = mensajes.max({m => m.peso()})

    method enviarNotificacion() = participantes.forEach ({p => self.notificar(p)})

    method notificar(p) = p.notificaciones().add(new Notificacion(chat = self))
}

class ChatPremium inherits Chat {
    var restriccion
    var creador 

    override method puedeEnviarMensaje(mensaje) = super(mensaje) and restriccion.puedeEnviarMensaje(mensaje, creador)
}

object difusion {
    method puedeEnviarMensaje(mensaje, creador) = mensaje.emisor() == creador   
}

object restringido{
    method puedeEnviarMensaje(mensaje, creador) = true //En la consigna no aparece asi, pero en la resolucion de la catedra si. Me quedo con esta 
                                                      //forma por temas de simplicidad, la otra implica mas atributos y bla bla. 
}

class Ahorro {
    var pesoMaximo 
    method puedeEnviarMensaje(mensaje, creador) = mensaje.peso() <= pesoMaximo 
}

class Notificacion {
    var leida = false
    var property chat

    method leer(valor) {leida = valor}
}