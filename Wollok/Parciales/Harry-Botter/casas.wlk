import bots.*

//Solucion usando mas de una clase --> No se cual seria la correcta // Finalmente usar esta es un quilombo por los hechizos. 
class Casa{ 
    var property integrantes = []

    method moreDirtOil() {
        const dirtOilStudents = integrantes.filter({e => e.aceitePuro()}) //Incluso se podria hacer el .size() aca
        return dirtOilStudents.size() > integrantes / 2
    }

    //Forma sin usar filter. Esta me da mas a C...
    method moreDirtOil2() {
        var contador = 0
        integrantes.forEach({e => if(e.aceitePuro()) contador += 1})
        return contador > integrantes / 2
    }
}

class CasaSinCondicion inherits Casa{
    var property peligrosa 
}

class CasaConCondicion inherits Casa{
    method peligrosa() = self.moreDirtOil()
}   

const gryffindor = new CasaSinCondicion(peligrosa = false)
const slytherin = new CasaSinCondicion(peligrosa = true)
const ravenclaw = new CasaConCondicion()
const hufflepuff = new CasaConCondicion()


//Usando una sola clase, no se si soy fan de esta solucion. --> Me termina sirviendo esta por el tema de los hechizos
class Casa2{ 
    var property integrantes = []
    var property hasConditions
    var property peligrosa2

    method peligroso2(_peligrosa) {
        if(hasConditions) { 
            peligrosa2 = self.moreDirtOil()
        }else {
            peligrosa2 = _peligrosa
        }
    }

    method moreDirtOil() {
        const dirtOilStudents = integrantes.filter({e => e.aceitePuro()}).size()
        return dirtOilStudents > integrantes / 2
    }
}

const gryffindor2 = new Casa2(integrantes = [], hasConditions = false, peligrosa2 = false)
const slytherin2 = new Casa2(integrantes = [], hasConditions = false, peligrosa2 = true)
const ravenclaw2 = new Casa2(integrantes = [], hasConditions = true, peligrosa2 = null)
const hufflepuff2 = new Casa2(integrantes = [], hasConditions = true, peligrosa2 = null)