import bots.*
import casas.*
import hechizos.*
import materias.* 

class Hechizero inherits Bot{
  var property hechizos = []
  var property casa = null

  method aprenderHechizo(hechizo) {
    hechizos.add(hechizo)
  }

  method esExperimentado() {
    return hechizos.size() > 3 and cargaElectrica > 50
  }

  method lanzarHechizo(hechizo, victima) {
    if(hechizo.requerimientos(self) and self.condPropia(hechizo)) {
        hechizo.consecuencias(victima)
    }
  }

  method estaActivo() = self.cargaElectrica() > 0

  method condPropia(hechizo) = self.estaActivo() and self.hechizos().contains(hechizo)

  override method puedeIrAHogwarts() = true

  method puedeSerProfesor() = false

  method ultimoHechizo() = hechizos.last()
}

class Estudiante inherits Hechizero{ 
    method asistirAclase(materia) {
        hechizos.add(materia.hechizoEnseniado())
    }
}

class Profesor inherits Hechizero {
  var property materias = [] 

  override method esExperimentado() {
    return super() and materias.size() >= 2
  }

  method darMateria(materia) {
    materias.add(materia)
  }

  override method disminuirCarga(valor) { if(valor == cargaElectrica) cargaElectrica /= 2}
  override method puedeSerProfesor() = true
}


const innombrable = new Hechizero(cargaElectrica = 1000, estadoAceite = true)