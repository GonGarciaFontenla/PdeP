class Torneo {
    var catadores = []
    var platosParticipantes = []

    method ganadorTorneo() {
        if(platosParticipantes.isEmpty()) throw new DomainException(message = "No hay platos participantes") 
        else platosParticipantes.max({p => self.calificacionTotal(p)}).cocinero()


        //platosParticipantes.max({p => }).max()
    }
    method calificacionTotal(p) = catadores.sum({c => c.catar(p)})
}