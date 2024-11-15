class Mision {
    var tipoMision

    method tipoMision() = tipoMision

    method copasAganar()
    method destrezaSuficiente()
    method estrategiaSuficiente()
    method repartirCopas()
    method sePuedeRealizar()

    method superarMision() = self.destrezaSuficiente() || self.estrategiaSuficiente()

    method participarMision() {
        if(self.sePuedeRealizar()) self.repartirCopas()
        else throw new DomainException(message = "Mision no puede comenzar")
    }

    method cantCopas() = tipoMision.cantCopasIncremento(self)
    method sumOrest() = if(self.superarMision()) 1 else -1
}

class MisionIndividual inherits Mision {
    var dificultad
    var personaje

    override method destrezaSuficiente() = personaje.destreza() > dificultad
    override method estrategiaSuficiente() = personaje.estrategia()

    override method copasAganar() = dificultad * 2

    override method repartirCopas() = personaje.darCopas(self.cantCopas() * self.sumOrest())

    override method sePuedeRealizar() = personaje.copas() >= 10

    method cantParticipantes() = 1
}

class MisionEquipo inherits Mision {
    var participantes //No se si dejarlo como numero o lista.... por ahora queda asi 

    override method copasAganar() = 50 / self.cantParticipantes()
    
    method cantParticipantes() = participantes.size()

    override method destrezaSuficiente() = participantes.all({p => p.destreza() > 400}) 

    override method estrategiaSuficiente() = self.cantEstrategicos() > self.cantParticipantes() / 2

    method cantEstrategicos() = participantes.filter({p => p.estrategia()}).size() //Seria mejor usar un count aca... no sabia de la existencia aun
    //method cantEstrategicos() = participantes.count({p => p.estrategia()}) Algo asi... te ahorras el .size()

    override method repartirCopas() = participantes.forEach({p => p.darCopas(self.cantCopas()*self.sumOrest())})

    override method sePuedeRealizar() = self.totalCopas() >= 60

    method totalCopas() = participantes.sum({p => p.copas()})
}

object misionComun {
    method cantCopasIncremento(mision) = mision.copasAganar()
}

class MisionBoost {
    var property multiplicador 

    method cantCopasIncremento(mision) = mision.copasAganar() * multiplicador
}

object misionBonus {
    method cantCopasIncremento(mision) = mision.copasAganar() + mision.cantParticipantes()
}