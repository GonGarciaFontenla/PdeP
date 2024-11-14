class Plato {
    method aptoCeliaco()
    method peso()

    method precio() = self.valoracion() * 300 + self.montoPorCeliaquia()

    method montoPorCeliaquia() = if(self.aptoCeliaco()) 1200 else 0

    method especial() = self.peso() > 250

    method valoracion() = self.peso() / 10
}

class Provoleta inherits Plato{
    const empanado

    override method aptoCeliaco() = empanado.negate() //!empanado

    override method especial() = super() and empanado

    override method valoracion() = if(self.especial()) 120 else 80
}

class Hamburguesa inherits Plato{
    const pesoMedallon
    const tipoPan

    override method peso() = pesoMedallon + tipoPan.peso()

    override method aptoCeliaco() = tipoPan.aptoCeliaco()
}

class HamburguesaDoble inherits Hamburguesa{
    override method especial() = self.peso() > 500

    override method peso() = pesoMedallon * 2 + tipoPan. peso() 
}

class Pan { 
    var property peso    
    var property aptoCeliaco 
}

const industrial = new Pan(peso = 60, aptoCeliaco = false)
const casero = new Pan(peso = 100, aptoCeliaco = false)
const maiz = new Pan(peso = 30, aptoCeliaco = true)

class Carne inherits Plato {
    const aPunto
    const peso

    override method especial() = super() and aPunto

    override method valoracion() = 100

    override method peso() = peso

    override method aptoCeliaco() = true
}

class Parrillada inherits Plato{
    var platos = []

    override method peso() = platos.sum({p => p.peso()})

    override method especial() = super() and platos.size() >= 3

    override method aptoCeliaco() = !platos.any({p => !p.aptoCeliaco()})
    //override method aptoCeliaco() = platos.all({p => p.aptoCeliaco()})

    override method valoracion() = platos.max({p => p.valoracion()}).valoracion()
}