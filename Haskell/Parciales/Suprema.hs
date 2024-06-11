module LibraryEli where
import PdePreludat
import Data.List (intersect)

-- --------------------- Dominio ---------------------------
data Ley = UnaLey{
    tema :: Tema,
    presupuesto :: Presupuesto,
    impulsadores :: [Impulsador]
}

data Juez = UnJuez {
    criterioVotacion :: Criterio
}

agendaActual :: Agenda
agendaActual = ["Uso Medicinal del Cannabis", "Educacion Superior"]

corteSupremaActual :: [Juez]
corteSupremaActual = [
    pepito, 
    manuelita, 
    richard, 
    ramona, 
    estebanquito, 
    amalia, 
    rodolfo,
    alejandra
    ]

-- --------------------- Definición de Tipos ----------------
type Tema = String
type Presupuesto = Number
type Impulsador = String
type Criterio = Ley -> Constitucionalidad
type Agenda = [Tema]
type CorteSuprema = [Juez]

type Constitucionalidad = Bool

-- --------------------- Ejemplos --------------------------
-- ---------------- Leyes
usoMedicinalCannabis :: Ley
usoMedicinalCannabis = UnaLey "Uso Medicinal del Cannabis" 5 ["Partido Cambio de Todos", "Sector Financiero"]

educacionSuperior :: Ley
educacionSuperior = UnaLey "Educacion Superior" 30 ["Docentes Universitarios", "Partido de Centro Federal"]

proTenistaMesa :: Ley
proTenistaMesa = UnaLey "Profesionalizacion del Tenista" 1 ["Liga de Deportistas Autonomos", "Club Paleta"]

tenis :: Ley
tenis = UnaLey "Tenis" 2 ["Liga de Deportistas Autonomos"]

-- ---------------- Jueces
pepito :: Juez
pepito = UnJuez {criterioVotacion = opinionPublica agendaActual}

manuelita :: Juez
manuelita = UnJuez {criterioVotacion = sectorEspecifico "Sector Financiero"}

richard :: Juez
richard = UnJuez {criterioVotacion = sectorEspecifico "Partido Conservador"}

ramona :: Juez
ramona = UnJuez {criterioVotacion = preocupadoArcas 10}

estebanquito :: Juez
estebanquito = UnJuez {criterioVotacion = preocupadoArcas 20}

amalia :: Juez
amalia = UnJuez {criterioVotacion = siempreOk}

rodolfo :: Juez
rodolfo = UnJuez {criterioVotacion = preocupadoArcas 3}

alejandra :: Juez
alejandra = UnJuez {criterioVotacion = juezInventado}

-- --------------------- Funciones -------------------------
-- -------------------- Constitucionalidad de las Leyes
-- Funcion 1
sonCompatibles :: Ley -> Ley -> Bool
sonCompatibles ley1 ley2 = estaIncluido (impulsadores ley1) (impulsadores ley2) && estaIncluido (tema ley1) (tema ley2)

estaIncluido :: Eq a => [a] -> [a] -> Bool
estaIncluido lista1 lista2 = (not . null) (intersect lista1 lista2) 

-- Funcion 2
opinionPublica :: Agenda -> Criterio
opinionPublica agenda ley = elem (tema ley) agenda 

sectorEspecifico :: Impulsador -> Criterio
sectorEspecifico impulsador ley = elem impulsador (impulsadores ley)

preocupadoArcas :: Number -> Criterio
preocupadoArcas delta = (<delta) . presupuesto 

juezInventado :: Criterio 
juezInventado = (>2). length . impulsadores

siempreOk :: Criterio
siempreOk ley = True


esConstitucional :: CorteSuprema -> Ley -> Bool
esConstitucional jueces ley = cantVotacion True jueces ley > cantVotacion False jueces ley 

cantVotacion :: Bool -> CorteSuprema -> Ley -> Number
cantVotacion bool jueces ley = length $ filter (bool ==) (votacion jueces ley)

votacion :: CorteSuprema -> Ley -> [Bool]
votacion jueces ley = map (constiSegunJuez ley) (map criterioVotacion jueces)

constiSegunJuez :: Ley -> Criterio -> Bool
constiSegunJuez ley juez = juez ley

-- Funcion 3
serianInconsti :: [Ley] -> CorteSuprema -> [Ley]
serianInconsti leyes corteSuprema = filter (not . esConstitucional corteSuprema) leyes

-- ------------- Cuestion de Principios
-- Funcion 1
borocotizar :: CorteSuprema -> CorteSuprema
borocotizar = map invertirJuez

invertirJuez :: Juez -> Juez
invertirJuez juez = juez{criterioVotacion = not . criterioVotacion juez}

-- Funcion 2
coincideSector :: Juez -> Impulsador -> [Ley] -> Bool
coincideSector juez sector leyes = all (elem sector . impulsadores) (leyesConstiSegunJuez juez leyes)
    
leyesConstiSegunJuez :: Juez -> [Ley] -> [Ley]
leyesConstiSegunJuez juez leyes = filter ((== True). flip constiSegunJuez (criterioVotacion juez)) leyes

-- ------------- Infinitoo

{-

Si hubiera una ley apoyada por infinitos sectores ¿puede ser declarada constitucional?
¿cuáles jueces podrián votarla y cuáles no? Justificar

Si, depende de los jueces que conformen a la corte suprema actual. Si por ejemplo
en la corte tenemos jueces que evaluan solo preocupados por las arcas, siempreOks, basados
en la opinion pública o sectores especificos, no importaría si la apoyan infinitos sectores. 
El problema llegaría, por ejemplo, con mi juez inventado, que necesita saber la longitud entera
de los impulsadores de la ley para evaluar. 

En el primer caso, Haskell se benficiaría de su lazy evaluation, primero teniendo en cuenta
la función especifica a ejecutar antes que a los parametros de entrada. De esta forma, ni tiene
en cuenta el hecho de que los impulsores son infinitos, sino que solo toma aquello que 
verdaderamente necesita. 

-}