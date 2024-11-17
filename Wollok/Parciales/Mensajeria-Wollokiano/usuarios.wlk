import chats.*

class Usuario {
    const memoria
    const chats 
    const notificaciones

    method tieneEspacioSuficiente(mensaje) = self.espacioOcupado() + mensaje.peso() <= memoria

    method espacioOcupado() = chats.sum({c => c.espacio()})

    method buscarMensaje(subMensaje) = chats.filter({c => c.contiene(subMensaje)})

    method mensajesMasPesados() = self.chatsConMensajesPropios().filter({c => c.mensajeMasPesado()})

    method chatsConMensajesPropios() = chats.forEach({c => self.enviadosXusuario(c)})

    method enviadosXusuario(c) = c.filter({m => m.emisor() == self})

    method leerChat(chat) {
		notificaciones.filter({n => n.chat() == chat}).forEach({n => n.leer()})
	}

    method notificacionesSinLeer() = notificaciones.filter({n => not n.leida()})
}