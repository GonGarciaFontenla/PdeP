module Library where
import PdePreludat
import System.Mem (performGC)
import GHC.Base (List)
import Text.ParserCombinators.ReadP (between)

doble :: Number -> Number
doble numero = numero + numero

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Number,
  precisionJugador :: Number
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Number,
  precision :: Number,
  altura :: Number
} deriving (Eq, Show)

type Puntos = Number

-- Funciones útiles
between' :: (Eq a, Enum a) => a -> a -> a -> Bool
between' n m x = elem x [n .. m]



{-
    Sabemos que cada palo genera un efecto diferente, por lo tanto elegir el palo correcto puede ser la diferencia entre ganar o perder el torneo.
    Modelar los palos usados en el juego que a partir de una determinada habilidad generan un tiro que se compone por velocidad, precisión y altura.

    --El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.
    --La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.
    --Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión
    dividida por n y una altura de n-3 (con mínimo 0). Modelarlos de la forma más genérica posible.
-}
type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = UnTiro {velocidad = 10 , precision = (*2)(precisionJugador habilidad) , altura = 0}

madera :: Palo
madera habilidad = UnTiro {velocidad = 100 , precision = (/2)(precisionJugador habilidad), altura = 5}

hierros :: Number -> Palo
hierros n habilidad = UnTiro {velocidad = (*n)(fuerzaJugador habilidad) , precision = (/n)(precisionJugador habilidad) , altura = calcularAltura n}

calcularAltura :: Number -> Number
calcularAltura n
    |n > 4 = n - 3
    |otherwise = 0

    --Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.
palos :: [Palo]
palos = [putter , madera] ++ map hierros [1 .. 10]

    --Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades de la persona.
golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = palo (habilidad jugador)

{-
    Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo, cómo se ve afectado 
    dicho tiro por el obstáculo. En principio necesitamos representar los siguientes obstáculos:

    --Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro.
    Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.

    --Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de superar una laguna el 
    tiro llega con la misma velocidad y precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna.

    --Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, 
    el tiro se detiene, quedando con todos sus componentes en 0.

    Se desea saber cómo queda un tiro luego de intentar superar un obstáculo, teniendo en cuenta que en caso de no superarlo, se detiene, 
    quedando con todos sus componentes en 0.
-}

data Obstaculo = Obstaculo {
    condicionSuperar :: Tiro -> Bool, 
    efecto :: Tiro -> Tiro
}deriving Show

intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro
intentarSuperarObstaculo obstaculo tiro
    |condicionSuperar obstaculo tiro = efecto obstaculo tiro
    |otherwise = tiroDetenido

laguna :: Number -> Obstaculo
laguna largo = Obstaculo superaLaguna (efectoLaguna largo) 

tunel :: Obstaculo
tunel = Obstaculo superaTunel efectoTunel

hoyo :: Obstaculo
hoyo = Obstaculo superarHoyo efectoHoyo

superaTunel :: Tiro -> Bool
superaTunel tiro = precision tiro > 90 && vaAlRas tiro 

superaLaguna :: Tiro -> Bool
superaLaguna tiro = velocidad tiro > 80 && between' 1 5 (altura tiro)

superarHoyo :: Tiro -> Bool
superarHoyo tiro = between' 5 20 (velocidad tiro) && vaAlRas tiro && precision tiro > 95

efectoTunel :: Tiro -> Tiro
efectoTunel tiro = UnTiro {velocidad = (*2)(velocidad tiro), precision = 100, altura = 0}

efectoLaguna :: Number -> Tiro -> Tiro
efectoLaguna numero tiro = UnTiro {velocidad = velocidad tiro, precision = precision tiro, altura = numero * altura tiro}

efectoHoyo :: Tiro -> Tiro
efectoHoyo tiro = tiroDetenido

tiroDetenido :: Tiro
tiroDetenido = UnTiro 0 0 0

vaAlRas :: Tiro -> Bool
vaAlRas tiro = altura tiro == 0

{-
    --Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.
    --Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
    --Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos con un solo tiro.
-}
type Palos = [Palo]
type Obstaculos = [Obstaculo]

palosUtiles :: Jugador -> Obstaculo -> Palos
palosUtiles jugador obstaculo = filter (sirveParaSuperar jugador obstaculo) palos

sirveParaSuperar :: Jugador -> Obstaculo -> Palo -> Bool
sirveParaSuperar jugador obstaculo palo = condicionSuperar obstaculo (golpe jugador palo)

obstaculosConsecutivos :: Tiro -> Obstaculos -> Number
obstaculosConsecutivos tiro [] = 0
obstaculosConsecutivos tiro (x:xs)
    |condicionSuperar x tiro = 1 + obstaculosConsecutivos (efecto x tiro) xs
    |otherwise = 0 

obstaculosConsecutivos' :: Tiro -> Obstaculos -> Number
obstaculosConsecutivos' tiro obstaculos = (length . takeWhile (\(obstaculo, tiroQueLeLlega ) -> condicionSuperar obstaculo tiro) . zip obstaculos . tirosSucesivos tiro) obstaculos

tirosSucesivos :: Tiro -> Obstaculos -> [Tiro]
tirosSucesivos tiroOriginal = foldl (\tirosGenerados obstaculos -> tirosGenerados ++ [efecto obstaculos (last tirosGenerados)]) [tiroOriginal]

maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

paloMasUtil :: Jugador -> Obstaculos -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip obstaculosConsecutivos obstaculos . golpe jugador) palos 

{-
Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo, se pide retornar la lista
de padres que pierden la apuesta por ser el “padre del niño que no ganó”. Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.
-}

jugadorDeTorneo = fst
puntosGanados = snd

pierdenLaApuesta :: [(Jugador, Puntos)] -> [String]
pierdenLaApuesta puntosDeTorneo = (map (padre.jugadorDeTorneo) . filter (not . gano puntosDeTorneo)) puntosDeTorneo

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano puntosDeTorneo puntosDeUnJugador = (all((<puntosGanados puntosDeUnJugador). puntosGanados) . filter (/= puntosDeUnJugador)) puntosDeTorneo
