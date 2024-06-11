module Library where
import PdePreludat

-- -------------------- Dominio -----------------------

data Fremen = UnFremen {
    nombre :: Nombre, 
    nivelTolerancia :: NivelTolerancia,
    titulos :: [Titulo],
    cantRecos :: Number 
} deriving (Eq, Show)

data GusanoArena = UnGusanoArena {
    longitud :: Longitud,
    nivelHidratacion :: NivelHidratacion,
    descripcion :: Descripcion
} deriving (Eq, Show)

-- -------------------- Definicion de Tipos -----------------------
type Tribu = [Fremen]
type Nombre = String
type NivelTolerancia = Number
type Titulo = String

type Longitud = Number
type NivelHidratacion = Number
type Descripcion = String

type OpComp = (NivelTolerancia -> Number -> Bool)

type Mision = GusanoArena -> Fremen -> Fremen
-- -------------------- Modelaje (Ejemplos) -----------------------
-- ---------------- Fremen
stilgar :: Fremen
stilgar = UnFremen {
    nombre = "Stilgar",
    nivelTolerancia = 150,
    titulos = ["Guia"],
    cantRecos = 3
}

-- ---------------- Gusanos
pepito :: GusanoArena
pepito = UnGusanoArena 10 5 "Rojo con Lunares"

samanta :: GusanoArena
samanta = UnGusanoArena 8 1 "Dientes Puntiagudos"

-- -------------------- Funciones Genericas -----------------------
-- ---------------- Fremen
toleranciaSegunF :: (NivelTolerancia -> NivelTolerancia) -> Fremen -> Fremen
toleranciaSegunF f fremen = fremen {nivelTolerancia = f . nivelTolerancia $ fremen}

titulosSegunF :: ([Titulo] -> [Titulo]) -> Fremen -> Fremen
titulosSegunF f fremen = fremen {titulos = f . titulos $ fremen}

cantRecosSegunF :: (Number -> Number) -> Fremen -> Fremen
cantRecosSegunF f fremen = fremen {cantRecos = f . cantRecos $ fremen}

-- -------------------- Funciones -----------------------
-- ------------------ Parte 1
-- Funcion 1
recibirReco :: Fremen -> Fremen 
recibirReco = cantRecosSegunF (+1)

-- Funcion 2
hayCanditadosElegido :: Tribu -> Bool
hayCanditadosElegido = any (condElegido (>) 100)  

condElegido :: OpComp -> NivelTolerancia -> Fremen -> Bool
condElegido op delta fremen = tieneTitulo "Domador" fremen && toleranciaEs op delta fremen

tieneTitulo :: Titulo -> Fremen -> Bool
tieneTitulo titulo = elem titulo . titulos

toleranciaEs :: OpComp -> NivelTolerancia -> Fremen -> Bool
toleranciaEs op delta = op delta . nivelTolerancia

-- Funcion 3
hallarElegido :: Tribu -> Fremen
hallarElegido = fremenMasRecos . candidatosElegido

candidatosElegido :: Tribu -> [Fremen]
candidatosElegido = filter (condElegido (>) 100)  

fremenMasRecos :: [Fremen] -> Fremen
fremenMasRecos [f] = f
fremenMasRecos (f1:f2:fs)
    | cantRecos f1 > cantRecos f2 = fremenMasRecos (f1:fs)
    | otherwise = fremenMasRecos (f2:fs)

-- ------------------ Parte 2
-- Funcion 1
reproduccionGusanos :: GusanoArena -> GusanoArena -> GusanoArena
reproduccionGusanos g1 g2 = UnGusanoArena (longCria g1 g2) 0 (descCria g1 g2)

longCria :: GusanoArena -> GusanoArena -> Longitud
longCria g1 g2 = max (longitud g1) (longitud g2) *0.1

descCria :: GusanoArena -> GusanoArena -> Descripcion
descCria g1 g2 = descripcion g1 ++ " - " ++ descripcion g2

-- Funcion 2
listaCrias :: [GusanoArena] -> [GusanoArena] -> [GusanoArena]
listaCrias [] _ = []
listaCrias _ [] = []
listaCrias (g1:gs1) (g2:gs2) = reproduccionGusanos g1 g2 : listaCrias gs1 gs2  

-- ------------------ Parte 3
-- Funcion 1
domarGusano :: Mision
domarGusano gusano fremen 
    | puedeDomarlo gusano fremen = cambiosPorDomar fremen
    | otherwise = toleranciaSegunF (*0.9) fremen

puedeDomarlo :: GusanoArena -> Fremen -> Bool
puedeDomarlo gusano = toleranciaEs (>=) (cantMinima gusano)
    
cantMinima :: GusanoArena -> NivelTolerancia
cantMinima = (/2) . longitud

cambiosPorDomar :: Fremen -> Fremen
cambiosPorDomar = titulosSegunF ("Domador" :) . toleranciaSegunF (+100)

-- Funcion 2
destruirGusano :: Mision
destruirGusano gusano fremen
    | puedeDestruirlo gusano fremen = cambiosPorDestruir fremen
    | otherwise = toleranciaSegunF (*0.8) fremen

puedeDestruirlo :: GusanoArena -> Fremen -> Bool
puedeDestruirlo gusano = condElegido (<) (cantMinima gusano) 

cambiosPorDestruir :: Fremen -> Fremen
cambiosPorDestruir = recibirReco . toleranciaSegunF (+100)

-- Funcion Inventada
montarGusano :: Mision
montarGusano gusano fremen 
    | puedeMontarlo fremen = cambiosPorMontar fremen
    | otherwise = titulosSegunF ("Perdedor" :) fremen

puedeMontarlo :: Fremen -> Bool
puedeMontarlo fremen = nombre fremen == "San Martin"

cambiosPorMontar :: Fremen -> Fremen
cambiosPorMontar = titulosSegunF ("Salvador de Arrakis" :) . recibirReco

-- Funcion 5
misionColectiva :: Mision -> GusanoArena -> Tribu -> Tribu
misionColectiva mision gusano = map (mision gusano) 

-- Funcion 6
misionCambiaElegido :: Tribu -> Mision -> GusanoArena -> Bool
misionCambiaElegido tribu mision gusano = 
    hallarElegido tribu /= hallarElegido (misionColectiva mision gusano tribu)

-- ------------------ TEORICO

{-

1) ¿Qué pasaría con una tribu de infinitos Fremen?
    a) Al querer saber si hay algún candidato a ser elegido.

    la respuesta se puede deducir a través del hecho que Haskell tiene
    un motor de evaluación diferida que, al contrario de la evaluación ansiosa,
    primero toma en cuenta las funciones y luego los parametros. 

    En este caso en particular, como la función es "any", Haskell va a revisar
    la lista hasta encontrar alguno que cumpla la condicion. En cuanto lo haga
    dejara de evaluarla y no importará si es infinita o no. Esto en el caso de que
    alguno de los infinitos fremen que se encuentren pueda ser un 
    candidato a elegido, si no hubiera ninguno entonces Haskell se quedaría
    evaluando por siempre, solo pudiendo ser interrumpido con un control c. 
    No produciría ningun resultado y se quedaría evaluando. 

    b) Al encontrar al elegido

    Como encontrarlo requiere de la función de orden superior "filter"
    que evalua la lista hasta el final, entonces nunca se podría llegar a un
    resultado, incluso si el primero cumple o si ninguno cumple. 

-}