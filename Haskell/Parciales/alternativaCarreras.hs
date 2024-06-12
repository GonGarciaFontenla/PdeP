--enunciado: https://docs.google.com/document/d/1g2Gc81R62_xAIiGF0H663ypAz1vxJybr5LDo1sj9tAU/edit#heading=h.ielqgky5ojzp

import Text.Show.Functions ()
import Data.List(genericLength, intersect)

--Punto 1
data Auto = Auto {
    color :: Color,
    velocidad :: Int,
    distanciaRecorrida :: Int
} deriving (Show, Eq)

data Color = Rojo | Blanco | Azul | Negro deriving (Show, Eq)

type Carrera = [Auto]

estaCerca :: Auto -> Auto -> Bool
estaCerca auto1 auto2 = (auto1 /= auto2) && (distanciaEntre auto1 auto2< 10)

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre auto1 auto2 = abs (distanciaRecorrida auto1 - distanciaRecorrida auto2)

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera = noHayNadieCerca auto carrera && vaPrimero auto carrera

noHayNadieCerca :: Auto -> Carrera -> Bool
noHayNadieCerca auto = not . any (estaCerca auto)

vaGanando :: Auto -> Auto -> Bool
vaGanando auto1 auto2 = distanciaRecorrida auto1 > distanciaRecorrida auto2

vaPrimero :: Auto -> Carrera -> Bool
vaPrimero auto = all (vaGanando auto)

puesto :: Auto -> Carrera -> Int
puesto auto carrera = 1 + length (filter (not . vaGanando auto) carrera)

--Punto 2:
correr :: Int -> Auto -> Auto
correr tiempo auto = auto {distanciaRecorrida = distanciaRecorrida auto + (tiempo * velocidad auto)}

alterarVelocidad :: (Int -> Int) -> Auto -> Auto
alterarVelocidad modificador auto = auto {velocidad = modificador (velocidad auto)}

bajarLaVelocidad :: Int -> Auto -> Auto
bajarLaVelocidad valor auto
    | velocidad auto - valor <= 0 = auto {velocidad = 0}
    | otherwise = auto {velocidad = velocidad auto - valor}

--Punto 3
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

type PowerUp = Auto -> Evento

terremoto :: PowerUp
terremoto auto = afectarALosQueCumplen (estaCerca auto) (bajarLaVelocidad 50)

miguelitos :: Int -> PowerUp
miguelitos valor auto = afectarALosQueCumplen (vaGanando auto) (bajarLaVelocidad valor)

jetPack :: Int -> PowerUp
jetPack tiempo auto = afectarALosQueCumplen (== auto) (efectoJetpack tiempo)

misilTeledirigido :: Color -> PowerUp
misilTeledirigido colorParam auto = afectarALosQueCumplen ((== colorParam) . color) impactar

impactar :: Auto -> Auto
impactar = bajarLaVelocidad 10

efectoJetpack :: Int -> Auto -> Auto
efectoJetpack tiempo = alterarVelocidad (`div` 2) . correr tiempo . alterarVelocidad (*2)

--Punto 4
type Evento = Carrera -> Carrera

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = tablaDePosiciones (obtenerEstadoFinal carrera eventos)

obtenerEstadoFinal :: Carrera -> [Carrera -> Carrera] -> Carrera
obtenerEstadoFinal = foldl (flip ($))

tablaDePosiciones :: Carrera -> [(Int , Color)]
tablaDePosiciones carrera = map (obtenerPuestoYColor carrera) carrera

obtenerPuestoYColor :: Carrera -> Auto -> (Int, Color)
obtenerPuestoYColor carrera auto = (puesto auto carrera, color auto)

correnTodos :: Int -> Evento
correnTodos tiempo = map (correr tiempo)

 --asumo que no puede haber 2 autos del mismo color en la carrera ya que en el enunciado no se especifica, pero te dice que recibis el color del auto que activó el power up y te habla como si este fuese un único auto, si pudieran existir autos del mismo color se necesitaria más información sobre quién gatilló el power up. De todas formas, dado el caso de que a esta funcion le lleue una carrera con mas de un auto con el mismo color, tomaría al primero que encuentre como el que gatilló el power up.
usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerup colorParam carrera = powerup (obtenerAutoQueGatillo colorParam carrera) carrera

obtenerAutoQueGatillo :: Color -> Carrera -> Auto
obtenerAutoQueGatillo colorParam carrera = head (filter ( (== colorParam) . color) carrera)

rojo :: Auto
rojo = Auto {
    color = Rojo,
    velocidad = 120,
    distanciaRecorrida = 0
}

blanco :: Auto
blanco = Auto {
    color = Blanco,
    velocidad = 120,
    distanciaRecorrida = 0
}

azul :: Auto
azul = Auto {
    color = Azul,
    velocidad = 120,
    distanciaRecorrida = 0
}

negro :: Auto
negro = Auto {
    color = Negro,
    velocidad = 120,
    distanciaRecorrida = 0
}

eventosEnunciado :: [Evento]
eventosEnunciado = [correnTodos 30, usaPowerUp (jetPack 3) Azul, usaPowerUp terremoto Blanco, correnTodos 40, usaPowerUp (miguelitos 20) Blanco, usaPowerUp (jetPack 6) Negro, correnTodos 10]

simularCarreraEnunciado :: [(Int, Color)]
simularCarreraEnunciado = simularCarrera carreraEnunciado eventosEnunciado

carreraEnunciado :: Carrera
carreraEnunciado = [rojo, blanco, negro, azul]

--Puede probarse el ejemplo por consola

--Punto 5
--a
-- Si, se podría integrar fácilmente con mi solución, de hecho lo hice mas arriba para comprobarlo, simplemente se crea un nuevo evento en el que el criterio sea el color del auto a impactar y el efecto sea el impacto, reutilizando tambinén la función de afectarALosQueCumplen

--b
-- Si una carrera se conformara por infinitos autos, ninguna de las funciones mencionadas podrían dar una respuesta ya que ambas implican comparar el auto con todo el resto de autos de la lista, si este no fuera el caso y se especificara la cantidad de autos a comparar o se quisiera medir un auto con respecto a otro utilizando índices fijos para la lista, si que sería posible obtener un resultado, ya que gracias a la lazy evaluation de haskell que primero se fija qué tiene que hacer y luego evalua los parámetros, solo tomará lo que necesite y no todo el resto de la lista infinita, la cual ni siquiera calculará. 