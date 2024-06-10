module Library where
import PdePreludat

-- -------------------- Dominio -----------------------

data Guantelete = UnGuantelete{
    material :: Material, 
    gemas :: [Gema]
} deriving (Show)

data Persona = UnaPersona{
    edad :: Number,
    energia :: Energia,
    habilidades :: [Habilidad],
    nombre :: Nombre,
    planeta :: Planeta
} deriving (Eq, Show)

-- -------------------- Defnición de Tipos -----------------------
type Material = String
type Habilidad = String
type Nombre = String
type Planeta = String
type Energia = Number

type Universo = [Persona]
type Gema = Persona -> Persona

-- -------------------- Funciones -------------------------
-- ----------------- Primera Parte
-- Punto 1
chasquidoUniverso :: Universo -> Guantelete -> Universo
chasquidoUniverso universo guante
    | estaCompleto guante =  eliminarMitad universo
    | otherwise = universo

eliminarMitad :: Universo -> Universo
eliminarMitad universo = drop (cantVictimas universo) universo

estaCompleto :: Guantelete -> Bool
estaCompleto guante = ((==6) . length . gemas) guante && material guante == "Uru"

cantVictimas :: Universo -> Number
cantVictimas universo = div (length universo) 2

--Punto 2
aptoPendex :: Universo -> Bool
aptoPendex = any ((<45) . edad) 

energiaTotalUniverso :: Universo -> Energia
energiaTotalUniverso = sum . map energia . filter ((>1). length . habilidades)

-- ----------------- Segunda Parte
-- Punto 3
-- Funcion 1
mente :: Number -> Gema
mente = debilitarEnergia

debilitarEnergia :: Number -> Persona -> Persona
debilitarEnergia delta enemigo = enemigo { 
    energia = energia enemigo - delta
    }

-- Funcion 2
alma :: Habilidad -> Gema
alma habilidad = debilitarEnergia 10 . quitarHabilidad habilidad

quitarHabilidad :: Habilidad -> Persona -> Persona
quitarHabilidad habilidad enemigo = enemigo { 
    habilidades = habilidadesSin habilidad enemigo
    }

habilidadesSin :: Habilidad -> Persona -> [Habilidad]
habilidadesSin habilidad enemigo = filter (/= habilidad) (habilidades enemigo)

-- Funcion 3
espacio :: Planeta -> Gema
espacio planetaX = debilitarEnergia 20 . transportarEnemigo planetaX

transportarEnemigo :: Planeta -> Persona -> Persona
transportarEnemigo planetaX enemigo = enemigo { 
    planeta = planetaX
    }

-- Funcion 4
poder :: Gema
poder enemigo = debilitarEnergia (energia enemigo) . quitarHabilidadSi $ enemigo

quitarHabilidadSi :: Persona -> Persona
quitarHabilidadSi enemigo
    | (<= 2) . length . habilidades $ enemigo  = enemigo { habilidades = []}
    | otherwise = enemigo

-- Funcion 5
tiempo :: Gema
tiempo = debilitarEnergia 50 . reducirEdad

reducirEdad :: Persona -> Persona
reducirEdad enemigo = enemigo{ edad = max 18 (div (edad enemigo) 2)}

-- Funcion 2
loca :: Gema -> Gema
loca gema = gema . gema

--Punto 4
guante :: Guantelete
guante = UnGuantelete "Goma" [tiempo, alma "Usar Mjolnir" 10, loca (alma "Programacion en Haskell" 4)]

--Punto 5
aplicarGemas :: [Gema] -> Gema
aplicarGemas = foldr (.) id

-- Punto 6
gemaMasPoderosa :: Guantelete -> Persona -> Gema
gemaMasPoderosa guante = evaluarPoderosa (gemas guante) 

evaluarPoderosa :: [Gema] -> Persona -> Gema
evaluarPoderosa [x] _ = x
evaluarPoderosa (gema1:gema2:gemas) enemigo 
    | mayorEnergia gema1 gema2 enemigo = evaluarPoderosa (gema1:gemas) enemigo
    | otherwise = evaluarPoderosa (gema2:gemas) enemigo

mayorEnergia :: Gema -> Gema -> Persona -> Bool
mayorEnergia gema1 gema2 enemigo = (energia . gema1) enemigo > (energia . gema2) enemigo

-- Punto 7
{-

gemaMasPoderosa punisher guanteleteDeLocos

Esta funcion no podría terminar de ejecutarse nunca, ya que al utilizar recursividad
su implementación requiere llegar al final de la cola (que no existe), por lo que
la máquina se quedaría infinitamente evaluando las gemas. 

usoLasTresPrimerasGemas guanteleteDeLocos punisher

Esta función si podría evaluarse ya que, aunque la lista es infinita, no se la requiere completa
Haskell al tener un motor de evaluacion diferida (lazy) primero va a entrar en la función, no en los 
parametros, se va a dar cuenta que solo necesita 3 y los va a tomar. Nunca va a analizar toda la estructura
porque no necesita hacerlo. 

-}