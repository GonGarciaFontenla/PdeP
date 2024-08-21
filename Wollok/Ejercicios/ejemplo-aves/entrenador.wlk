import josefa.*
import pepita.*
import beti.*

object entrenador {
    method entrenar(pajaro) {
        pajaro.comer(10)
        pajaro.volar(20)
        if(pajaro.energia() < 20)
            pajaro.comer(10)
        else
            pajaro.comer(2)
    }  
}