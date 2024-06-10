module Library where
import PdePreludat

data Auto = Auto {
  color :: String,
  velocidad :: Number,
  distanciaRecorrida :: Number
} deriving (Show, Eq)

type Carrera = [Auto]

estaCerca :: Auto -> Auto -> Bool 
estaCerca auto1 auto2 
  = auto1 /= auto2 
    && distanciaEntre auto1 auto2 < 10

distanciaEntre :: Auto -> Auto -> Number 
distanciaEntre auto1
  = abs . (distanciaRecorrida auto1 -) . distanciaRecorrida

vaTranquilo :: Auto -> Carrera -> Bool 
vaTranquilo auto carrera 
  = (not.tieneAlgunAutoCerca auto) carrera
      && vaGanando auto carrera

tieneAlgunAutoCerca :: Auto -> Carrera -> Bool 
tieneAlgunAutoCerca auto = any (estaCerca auto) 

vaGanando :: Auto -> Carrera -> Bool
vaGanando auto 
  = all (leVaGanando auto) . filter (/= auto)

leVaGanando :: Auto -> Auto -> Bool
leVaGanando ganador = (< distanciaRecorrida ganador).distanciaRecorrida

puesto :: Auto -> Carrera -> Number 
puesto auto = (1 +) . length . filter (not . leVaGanando auto) 

correr :: Number -> Auto -> Auto
correr tiempo auto = auto {
    distanciaRecorrida = distanciaRecorrida auto +
        tiempo * velocidad auto
}

type ModificadorDeVelocidad = Number -> Number
alterarVelocidad :: ModificadorDeVelocidad -> Auto -> Auto
alterarVelocidad modificador auto =
    auto { velocidad = (modificador . velocidad) auto}

bajarVelocidad :: Number -> Auto -> Auto
bajarVelocidad velocidadABajar 
  = alterarVelocidad (max 0 . subtract velocidadABajar)

------

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

type PowerUp = Auto -> Carrera -> Carrera
terremoto :: PowerUp
terremoto autoQueGatillo =
    afectarALosQueCumplen (estaCerca autoQueGatillo) (bajarVelocidad 50)

miguelitos :: Number -> PowerUp
miguelitos velocidadABajar autoQueGatillo =
    afectarALosQueCumplen (leVaGanando autoQueGatillo) (bajarVelocidad velocidadABajar)

jetPack :: Number -> PowerUp
jetPack tiempo autoQueGatillo =
    afectarALosQueCumplen (== autoQueGatillo)
        (alterarVelocidad (\ _ -> velocidad autoQueGatillo) 
          . correr tiempo . alterarVelocidad (*2))

type Color = String
type Evento = Carrera -> Carrera
simularCarrera :: Carrera -> [Evento] -> [(Number, Color)]
simularCarrera carrera eventos = (tablaDePosiciones . procesarEventos eventos) carrera

tablaDePosiciones :: Carrera -> [(Number, Color)]
tablaDePosiciones carrera 
  = map (entradaDeTabla carrera) carrera

entradaDeTabla :: Carrera -> Auto -> (Number, String)
entradaDeTabla carrera auto = (puesto auto carrera, color auto)

tablaDePosiciones' :: Carrera -> [(Number, String)]
tablaDePosiciones' carrera 
  = zip (map (flip puesto carrera) carrera) (map color carrera)

procesarEventos :: [Evento] -> Carrera -> Carrera
procesarEventos eventos carreraInicial =
    foldl (\carreraActual evento -> evento carreraActual) 
      carreraInicial eventos

procesarEventos' eventos carreraInicial =
    foldl (flip ($)) carreraInicial eventos

correnTodos :: Number -> Evento
correnTodos tiempo = map (correr tiempo)

usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerUp colorBuscado carrera =
    powerUp autoQueGatillaElPoder carrera
    where autoQueGatillaElPoder = find ((== colorBuscado).color) carrera

find :: (c -> Bool) -> [c] -> c
find cond = head . filter cond

ejemploDeUsoSimularCarrera =
    simularCarrera autosDeEjemplo [
        correnTodos 30,
        usaPowerUp (jetPack 3) "azul",
        usaPowerUp terremoto "blanco",
        correnTodos 40,
        usaPowerUp (miguelitos 20) "blanco",
        usaPowerUp (jetPack 6) "negro",
        correnTodos 10
    ]

autosDeEjemplo :: [Auto]
autosDeEjemplo = map (\color -> Auto color 120 0) ["rojo", "blanco", "azul", "negro"]

---- Punto 5
{-

5a

Se puede agregar sin problemas como una función más misilTeledirigido :: Color -> PowerUp, y usarlo como:
usaPowerUp (misilTeledirigido "rojo") "azul" :: Evento


5b

- vaTranquilo puede terminar sólo si el auto indicado no va tranquilo
(en este caso por tener a alguien cerca, si las condiciones estuvieran al revés, 
terminaría si se encuentra alguno al que no le gana).
Esto es gracias a la evaluación perezosa, any es capaz de retornar True si se encuentra alguno que cumpla 
la condición indicada, y all es capaz de retornar False si alguno no cumple la condición correspondiente. 
Sin embargo, no podría terminar si se tratara de un auto que va tranquilo.

- puesto no puede terminar nunca porque hace falta saber cuántos le van ganando, entonces por más 
que se pueda tratar de filtrar el conjunto de autos, nunca se llegaría al final para calcular la longitud.

-}