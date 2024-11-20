// Los juegos reciben críticas, que se utilizan para orientar a los futuros compradores sobre qué juego
// comprar.
// Las críticas pueden venir de varias fuentes:
// - De usuarios, en cuyo caso, según cada uno, pueden ser tanto positivas como negativa y el
// texto es un simple "SI" o "NO". Un usuario puede cambiar su predisposición a votar negativa
// o positivamente en cualquier momento.
// - De críticos pagos, en cuyo caso son positivos cuando el juego está en la lista de juegos que
// le pagaron. Siempre contienen un texto que consiste en palabras random. Un críticos pago
// puede recibir pagos de nuevos juegos y de esta manera algún juego que antes calificaba
// negativamente, a partir de ese momento lo califica positivamente. O al revés. Pero siempre
// se comporta de la misma manera.
// - De revistas, que sólo son positivas si la mayoría de los críticos que conforman dicha revista
// califican positivamente (estos críticos pueden ser pagos o usuarios comunes). El texto de la
// crítica es la concatenación de los textos de los críticos. Una revista puede incorporar o perder
// críticos, y en función de ello también puede que en diferentes oportunidades califique
// diferente a un mismo juego.
// Más allá de su origen, sin embargo, todas las críticas valen lo mismo.

class Critica {
  var texto
  var esPositiva

  method esPositiva() = esPositiva
}

object positiva {
    method texto() = "SI"
    method esPositiva() = true
}

object negativa {
    method texto() = "NO"
    method esPositiva() = false
}

class Fuente {

}

class Usuario {

}

class CriticoPago inherits Fuente {

}
