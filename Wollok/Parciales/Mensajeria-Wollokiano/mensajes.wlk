class Mensajes {
  var emisor
  var contenido

  method peso() = 5 + contenido.peso() * 1.3

  method contiene(texto) = emisor.contiene(texto) or contenido.contiene(texto)
}

class Texto {
  var texto
  method peso() = texto.size()

  method contiene(_texto) = texto.contains(_texto)
}

class Audio {
  var duracion

  method peso() = 1.2 * duracion

  method contiene(texto) = false
}

class Contacto {
  const usuario

  method peso() = 3

  	method contiene(texto) = usuario.contiene(texto)
}

class Imagen {
  var alto
  var ancho
  var comprension

  method cantidadPixeles() = alto * ancho

  method peso() = comprension.pixelesAenviar(self.cantidadPixeles()) * 2

  method contiene(texto) = false
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