module Library where
import PdePreludat

type Trabajo = String
type Actividad = Personaje -> Personaje
type Actividades = [Actividad]

data Personaje = Personaje {
    nombre :: String, 
    dinero :: Number, 
    felicidad :: Number
}deriving (Show, Eq)

lisa :: Personaje 
lisa = Personaje "Lisa" 30 150

bart :: Personaje 
bart = Personaje "Bart" 6 100

homero :: Personaje
homero = Personaje "Homero" 1 50

skinner :: Personaje
skinner = Personaje "Skinner" 500 100

burns :: Personaje
burns = Personaje "Sr. Burns" 100000000 0

irEscuela :: Actividad
irEscuela personaje
    |personaje == lisa = modificarFelicidad 20 lisa
    |otherwise = modificarFelicidad (-20) personaje

comerNrosquillas :: Number -> Actividad
comerNrosquillas n personaje
    |n > 0 = comerNrosquillas (n-1) (comerUnaRosquilla personaje)
    |otherwise = personaje

trabajar :: Trabajo -> Actividad
trabajar trabajo = modificarDinero (length trabajo)

trabajarDirector :: Actividad
trabajarDirector = modificarFelicidad (-20) . trabajar "escuela elemental"

personificarABurns :: Actividad
personificarABurns personaje 
    |personaje == burns = personaje
    |otherwise = modificarDinero (dinero burns) (modificarNombre "Fake Sr.Burns" personaje)

comerUnaRosquilla :: Personaje -> Personaje
comerUnaRosquilla = modificarFelicidad 10 . modificarDinero (-10)

modificarFelicidad :: Number -> Personaje -> Personaje
modificarFelicidad valor personaje = personaje {felicidad = max 0 (felicidad personaje + valor)}

modificarDinero :: Number -> Personaje -> Personaje
modificarDinero valor personaje = personaje {dinero = dinero personaje + valor}

modificarNombre :: String -> Personaje -> Personaje
modificarNombre nombre personaje = personaje {nombre = nombre}

{-
comerNrosquillas 12 homero
Personaje {nombre = "Homero", dinero = -20, felicidad = 170}
-}

{-
trabajarDirector skinner
Personaje {nombre = "Skinner", dinero = 517, felicidad = 80}
-}

{-
personificarABurns . irEscuela $ lisa
Personaje {nombre = "Fake Sr.Burns", dinero = 1000030, felicidad = 170}
-}

--Logros
type Logro = Personaje -> Bool

serMillonario :: Logro
serMillonario personaje = esMayor (dinero personaje) (dinero burns)

alegrarse :: Number -> Logro
alegrarse felicidadDeseada personaje = esMayor (felicidad personaje) felicidadDeseada

verProgramaKrosti :: Logro
verProgramaKrosti personaje = (>= 10) (dinero personaje)

nombreMasLargoQue ::Number -> Personaje -> Bool
nombreMasLargoQue largoDeseado personaje = esMayor (length (nombre personaje)) largoDeseado

esMayor :: Number -> Number -> Bool
esMayor n1 n2 = (> n2) n1

actividadDecisiva :: Personaje -> Logro -> Actividad -> Bool
actividadDecisiva personaje logro activadad = logro (activadad personaje)

actividadesDecisivas :: Personaje -> Logro -> Actividades -> Actividades
actividadesDecisivas personaje logro = filter (actividadDecisiva personaje logro)

primeraActividadDecisiva :: Personaje -> Logro -> Actividades -> Personaje
primeraActividadDecisiva personaje logro actividades = head (actividadesDecisivas personaje logro actividades) personaje

listaInfinita :: Actividades
listaInfinita = cycle [trabajar "mafia", irEscuela]

listaInfinita' :: Actividades
listaInfinita' = cycle [trabajar "maf", irEscuela]

{-
Primer ejemplo: 

    ghci> primeraActividadDecisiva bart verProgramaKrosti listaInfinita 
    Personaje {nombre = "Bart", dinero = 11, felicidad = 100}}

Este ejemplo da una respuesta debido a la lazy evaluation de Haskell. Como Haskell detecta que hay una actividad
decisiva, aplica esa actividad al personaje y retorna ese personaje luego de la actividad, sin necesidad de 
tener la lista completa. 

    ghci> primeraActividadDecisiva bart verProgramaKrosti listaInfinita' 
En este caso, como ninguna actividad es decisiva continua iterando infinitamente sobre la lista hasta un stack overflow.
-}