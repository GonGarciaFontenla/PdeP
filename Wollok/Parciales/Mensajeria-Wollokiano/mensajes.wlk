class Mensajes {
  var remitente
  var contenido

  method peso() = 5 + contenido.peso() * 1.3
}

class Texto {
  var texto
  method peso() = texto.size()
}

class Audio {
  var duracion

  method peso() = 1.2 * duracion
}

class Contacto {
  method peso() = 3
}

class Imagen {
  var alto
  var ancho
  var comprension

  method cantidadPixeles() = alto * ancho

  method peso() = comprension.pixelesAenviar(self.cantidadPixeles()) * 2
}

class Gif inherits Imagen {
  var cuadros

  override method peso() = super() * cuadros
}

object compresionOriginal {
  method pixelesAenviar(pixeles) = pixeles
}

class Compresionvariable {
  var porcentaje

  method pixelesAenviar(pixeles) = pixeles * porcentaje
}

object compresionMaxima {
  method pixelesAenviar(pixeles) = pixeles.min(10000)
}