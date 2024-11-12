import bots.*
import casas.*
import hechizeros.*
import materias.*
import hechizos.*

object hogwarts {
    var property grupoAlumnos = []

    method grupoAsisteAMateria(materia) {
		grupoAlumnos.forEach({a => a.asistirAclase(materia)})
	}

    method grupoLanzaHechizos(victima) {
        grupoAlumnos.forEach({a => a.lanzarHechizo(a.ultimoHechizo(), victima)})
    }

    method crearMateria(profe, hechizo) {
        if(profe.puedeSerProfesor()) {
            const materia = new Materia(profesor = profe, hechizoEnseniado = hechizo)
            profe.darMateria(materia)
            return materia
        }else 
            throw new UserException(message = "Solo los profesores pueden dar clases!!!!")
    }
}
