--enunciado: //docs.google.com/document/d/1rbOy1rIFmBxMRhTOWvI-u097l9KatHRbqt5KBXvVSfI/edit

import Text.Show.Functions () 
import Data.List(genericLength)

data Nave = Nave {
    nombre :: String,
    durabilidad :: Float,
    escudo :: Float,
    ataque :: Float,
    poder :: Poder
} deriving (Show)

type Poder = Nave -> Nave

--Punto 1
tieFighter :: Nave
tieFighter = Nave {
    nombre = "TIE Fighter",
    durabilidad = 200,
    escudo = 100,
    ataque = 50,
    poder = movimientoTurbo
}

movimientoTurbo :: Poder
movimientoTurbo = modificarAtaque (+25)

xWing :: Nave
xWing = Nave {
    nombre = "X Wing",
    durabilidad = 300,
    escudo = 150,
    ataque = 100,
    poder = reparacionEmergencia
}

reparacionEmergencia :: Poder
reparacionEmergencia = modificarDurabilidad (+50) . modificarAtaque (flip (-) 30)

naveDarthVader :: Nave
naveDarthVader = Nave {
    nombre = "Nave de Darth Vader",
    durabilidad = 500,
    escudo = 300,
    ataque = 200,
    poder = movimientoSuperTurbo
}

movimientoSuperTurbo :: Poder
movimientoSuperTurbo = modificarDurabilidad (flip (-) 45) . movimientoTurbo . movimientoTurbo . movimientoTurbo

milleniumFalcon :: Nave
milleniumFalcon = Nave {
    nombre = "Millennium Falcon",
    durabilidad = 1000,
    escudo = 500,
    ataque = 50,
    poder = reparacionEmergencia . modificarEscudo (+100)
}

flyBerty :: Nave
flyBerty = Nave {
    nombre = "Fly Berty",
    durabilidad = 500,
    escudo = 500,
    ataque = 500,
    poder = superSayajin
}

superSayajin :: Poder
superSayajin = modificarAtaque (*50) . modificarDurabilidad (*50) . modificarEscudo (*50)

modificarDurabilidad :: (Float->Float) -> Nave -> Nave
modificarDurabilidad f nave 
    | f (durabilidad nave) < 0 = nave {durabilidad = 0}
    | otherwise = nave {durabilidad = f . durabilidad $ nave}

modificarEscudo :: (Float->Float) -> Nave -> Nave
modificarEscudo f nave 
    | f (escudo nave) < 0 = nave {escudo = 0}
    | otherwise = nave {escudo = f . escudo $ nave}

modificarAtaque :: (Float->Float) -> Nave -> Nave
modificarAtaque f nave 
    | f (ataque nave) < 0 = nave {ataque = 0}
    | otherwise = nave {ataque = f . ataque $ nave}

--Punto 2
type Flota = [Nave]

durabilidadTotal :: Flota -> Float
durabilidadTotal  = sum . map durabilidad 

--Punto 3
ataqueNaves :: Nave -> Nave -> Nave
ataqueNaves atacante atacada = ataqueNaves' (activarPoder atacante) (activarPoder atacada)
ataqueNaves' :: Nave -> Nave -> Nave
ataqueNaves' atacante atacada
    | escudo atacada > ataque atacante = atacada
    | otherwise = modificarDurabilidad (flip (-) (daño atacante atacada)) atacada

activarPoder :: Nave -> Nave
activarPoder nave = poder nave nave

daño :: Nave -> Nave -> Float
daño atacante atacada = ataque atacante - escudo atacada


--Punto 4
fueraDeCombate :: Nave -> Bool
fueraDeCombate nave = durabilidad nave == 0
fueraDeCombate' :: Nave -> Bool
fueraDeCombate'  = (==0) . durabilidad

--Punto 5
type Estrategia = Nave -> Bool

misionSorpresa :: Nave -> Flota -> Estrategia -> Flota
misionSorpresa atacante flotaEnemiga estrategia = filter estrategia flotaEnemiga

naveDebil :: Estrategia
naveDebil nave = escudo nave < 200

naveConCiertaPeligrosidad :: Float -> Estrategia
naveConCiertaPeligrosidad peligrosidad = (>peligrosidad) . ataque

quedarianFueraDeCombate :: Nave -> Estrategia
quedarianFueraDeCombate atacante  = fueraDeCombate . ataqueNaves atacante

naveFragil :: Estrategia
naveFragil nave = durabilidad nave < 500

--Punto 6
misionSorpresaConEstrategiaOptima :: Nave -> Flota -> Estrategia -> Estrategia -> Flota
misionSorpresaConEstrategiaOptima nave flota estrategia1 estrategia2 = misionSorpresa nave flota (minimizaDurabilidad nave flota estrategia1 estrategia2)

minimizaDurabilidad :: Nave -> Flota -> Estrategia -> Estrategia -> Estrategia
minimizaDurabilidad nave flota estrategia1 estrategia2
    | durabilidadTotal (misionSorpresa nave flota estrategia1) <= durabilidadTotal (misionSorpresa nave flota estrategia1) = estrategia1
    | durabilidadTotal (misionSorpresa nave flota estrategia1) >= durabilidadTotal (misionSorpresa nave flota estrategia1) = estrategia1

--Punto 7
navesInterminables :: Flota
navesInterminables = cycle [tieFighter, xWing, naveDarthVader, milleniumFalcon, flyBerty]
-- Si realizara una mision sobre esta flota, no se obtendria respuesta, ya que ninguna de las estrategias implica que TODAS o ALGUNA nave cumpla una condición, por tanto no dejaría nunca de chequear si la siguienta en la lista la cumple o no.
