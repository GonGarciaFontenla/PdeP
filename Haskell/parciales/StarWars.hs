module Library where
import PdePreludat
import GHC.Num (Num)
import System.Mem (performGC)

doble :: Number -> Number
doble numero = numero + numero

{-
Las fuerzas rebeldes analizan diferentes estrategias para enfrentarse a las naves espaciales imperiales de Darth Vader. 
Debido a los bajos números de la resistencia decidieron que por cada flota enemiga van a enviar a una única nave para
llevar adelante misiones sorpresa. Para ello, decidieron hacer un programa en Haskell Espacial que les permita planificar 
adecuadamente la lucha contra el lado oscuro simulando estos combates.
De todas las naves conociendo su durabilidad, su ataque, su escudo y su poder especial. A modo de ejemplo se presentan algunas: 
-}

type Poder = Nave -> Nave  
type Poderes = [Poder]

data Nave = Nave {
    nombre :: String, 
    durabilidad :: Number, 
    escudo :: Number, 
    ataque :: Number,
    poder :: Poder
}deriving Show

tiefigther :: Nave
tiefigther = Nave "TIE-Figther" 200 100 500 movimientoTurbo

xwing :: Nave
xwing = Nave "X-Wing" 300 150 100 reparacionEmergencia

naveDarthVader :: Nave
naveDarthVader = Nave "Nave de Darth Vader" 500 300 200 movimientoSuperTurbo

millenniumFalcon :: Nave
millenniumFalcon = Nave "Millennium Falcon" 1000 500 50 reparacionEmergencia'

starship :: Nave
starship = Nave "Starship" 2000 1000 200 movimientoTurbo

movimientoTurbo :: Poder
movimientoTurbo = modificarAtaque 30

reparacionEmergencia :: Poder
reparacionEmergencia nave = modificarAtaque (-30) (reducirDurabilidad 50 nave)

movimientoSuperTurbo :: Poder
movimientoSuperTurbo nave = aplicarNveces 3 movimientoTurbo (reducirDurabilidad 45 nave)

reparacionEmergencia' :: Poder
reparacionEmergencia' = reparacionEmergencia . incrementarEscudo 100

elonAtaque :: Poder
elonAtaque = movimientoTurbo . reparacionEmergencia . movimientoSuperTurbo

modificarAtaque :: Number -> Nave -> Nave
modificarAtaque valor nave = nave {ataque = ataque nave + valor}

reducirDurabilidad :: Number -> Nave -> Nave
reducirDurabilidad valor nave = nave {durabilidad = durabilidad nave - valor}

aplicarNveces :: Number -> Poder -> Nave -> Nave
aplicarNveces cantidad poder nave
    |cantidad > 0 = aplicarNveces (cantidad - 1) poder nave
    |otherwise = nave

incrementarEscudo :: Number -> Nave -> Nave
incrementarEscudo valor nave = nave {escudo = escudo nave + valor}

--Calcular la durabilidad total de una flota, formada por un conjunto de naves, 
--que es la suma de la durabilidad de todas las naves que la integran.

type Flota = [Nave]

durabilidadFlota :: Flota -> Number
durabilidadFlota [] = 0
durabilidadFlota (x:xs) = durabilidad x + durabilidadFlota xs

--Otra opcion: 
durabilidadFlota' :: Flota -> Number
durabilidadFlota' = foldl (flip((+) . durabilidad)) 0 

--Otra opcion: 
durabilidadFlota'' :: Flota -> Number
durabilidadFlota'' = foldr ((+) . durabilidad) 0 

{-
Saber cómo queda una nave luego de ser atacada por otra. 
Cuando ocurre un ataque ambas naves primero activan su poder especial y luego la nave atacada 
reduce su durabilidad según el daño recibido, que es la diferencia entre el ataque de la atacante
y el escudo de la atacada. (si el escudo es superior al ataque, la nave atacada no es afectada).
La durabilidad, el escudo y el ataque nunca pueden ser negativos, a lo sumo 0.
-}

ataqueAnave :: Nave -> Nave -> Nave
ataqueAnave = aplicarAtaque 

aplicarAtaque :: Nave -> Nave -> Nave
aplicarAtaque nave1 nave2
    |escudoAtacada nave1 < ataqueAtacante nave2 = nave1 {durabilidad = durabilidad nave1 - (ataqueAtacante nave2 - escudoAtacada nave1)} 
    |otherwise = nave1

ataqueAtacante :: Nave -> Number
ataqueAtacante = ataque . aplicarPoder

escudoAtacada :: Nave -> Number
escudoAtacada = escudo . aplicarPoder

aplicarPoder :: Nave -> Nave
aplicarPoder nave = poder nave nave

--Averiguar si una nave está fuera de combate, lo que se obtiene cuando su durabilidad llegó a 0. 
fueraCombate :: Nave -> Estrategia
fueraCombate nave1 nave2 = durabilidad (ataqueAnave nave1 nave2) <= 0

--Otra forma mas pro: 
fueraCombate' :: Nave -> Estrategia
fueraCombate' nave1 nave2 = (<= 0) (durabilidad (ataqueAnave nave1 nave2))

{-
Averiguar cómo queda una flota enemiga luego de realizar una misión sorpresa con una nave siguiendo una estrategia. 
Una estrategia es una condición por la cual la nave atacante decide atacar o no una cierta nave de la flota. 
Por lo tanto la misión sorpresa de una nave hacia una flota significa atacar todas aquellas naves de la flota que 
la estrategia determine que conviene atacar. Algunas estrategias que existen, y que deben estar reflejadas en la solución, son:

1. Naves débiles: Son aquellas naves que tienen menos de 200 de escudo.
2. Naves con cierta peligrosidad: Son aquellas naves que tienen un ataque mayor a un valor dado. Por ejemplo, en alguna misión 
se podría utilizar una estrategia de peligrosidad mayor a 300, y en otra una estrategia de peligrosidad mayor a 100.
3. Naves que quedarían fuera de combate: Son aquellas naves de la flota que luego del ataque de la nave atacante quedan fuera de combate. 
4. Inventar una nueva estrategia
-}
type Estrategia = Nave -> Bool

naveDebil :: Estrategia
naveDebil nave = escudo nave < 200

navePeligrosa :: Number -> Estrategia
navePeligrosa valor nave = ataque nave > valor

naveDebilPeligrosa :: Estrategia
naveDebilPeligrosa nave = naveDebil nave && navePeligrosa 100 nave

mision :: Nave -> Flota -> Estrategia -> Flota
mision _ [] _ = []
mision nave (x:xs) estrategia
    |estrategia x = ataqueAnave x nave : mision nave xs estrategia
    |otherwise = x : mision nave xs estrategia

{-
Considerando una nave y una flota enemiga en particular, dadas dos estrategias, determinar cuál de ellas 
es la que minimiza la durabilidad total de la flota atacada y llevar adelante una misión con ella.
-}

mejorEstrategia :: Nave -> Flota -> Estrategia -> Estrategia -> Flota
mejorEstrategia nave flota estrategia1 estrategia2
    |compararEstrategias nave flota estrategia1 estrategia2 = mision nave flota estrategia2
    |otherwise = mision nave flota estrategia1 

compararEstrategias :: Nave -> Flota -> Estrategia -> Estrategia -> Bool
compararEstrategias nave flota estrategia1 estrategia2 = 
    durabilidadFlota (mision nave flota estrategia1) >  durabilidadFlota (mision nave flota estrategia2)

{-
Construir una flota infinita de naves. ¿Es posible determinar su durabilidad total? 
¿Qué se obtiene como respuesta cuando se lleva adelante una misión sobre ella? Justificar conceptualmente.
-}

flotaInfinita :: Flota
flotaInfinita = cycle [tiefigther, xwing, naveDarthVader, millenniumFalcon, starship]

{-
No es posible determinar su durabilidad total ya que la lista es infinita, por ende no se podrian terminar las sumatorias jamas.
Eventualmente arrojaria un stack overflow, lo que quiere decir que se acaba el stack de la pila.
-}


{-
No se podria llevar a cabo una mision sobre esta flota ya que al ser infinita, la mision nunca terminaria de ejecutarse.
-}