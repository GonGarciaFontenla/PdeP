module LibraryEli2 where
import Data.List (intersect)
import PdePreludat

-- --------------------------- Dominio -----------------------
data Ninja = UnNinja {
    nombre :: Nombre,
    herramientas :: [Herramienta],
    jutsus :: [Jutsu],
    rango :: Rango
} deriving (Eq, Show)

data Mision = UnaMision {
    cantNinjas :: Number,
    rangoRecomendado :: Rango, 
    enemigos :: [Ninja],
    recompensa :: Herramienta
} deriving (Eq, Show)

-- --------------------------- Definición de Tipos -----------------------
type Nombre = String
type Jutsu = Mision -> Mision
type Rango = Number
type Equipo = [Ninja]
type Herramienta = (Nombre, Number)

-- --------------------------- Funciones Genericas -----------------------
-- -------------- Ninjas
rangoSegunF :: (Rango -> Rango) -> Ninja -> Ninja
rangoSegunF f ninja = ninja { rango = max 0 . f . rango $ ninja }

cantSegunF :: (Number -> Number) -> Herramienta -> Herramienta
cantSegunF f (nombre, cant) = (nombre, f cant)

herramientasSegunF :: ([Herramienta] -> [Herramienta]) -> Ninja -> Ninja
herramientasSegunF f ninja = ninja { herramientas = f . herramientas $ ninja }

herramientaNombre :: Herramienta -> String
herramientaNombre = fst

-- -------------- Misión
cantNinjasSegunF :: (Number -> Number) -> Mision -> Mision
cantNinjasSegunF f mision = mision { cantNinjas = max 1 . f . cantNinjas $ mision }

enemigosSegunF :: ([Ninja] -> [Ninja]) -> Mision -> Mision
enemigosSegunF f mision = mision { enemigos = f . enemigos $ mision }

-- --------------------------- Funciones -----------------------
-- ------------ Parte A
-- Funcion A

obtenerHerramienta :: Herramienta -> Ninja -> Ninja
obtenerHerramienta herramienta ninja = herramientasSegunF (agregarHerramienta herramienta ninja) ninja
    
agregarHerramienta :: Herramienta -> Ninja -> ([Herramienta] -> [Herramienta])
agregarHerramienta herramienta ninja = 
    ((cantSegunF . min . cantPosible) ninja herramienta :)

cantPosible :: Ninja -> Number
cantPosible = (100 -) . cantHerramientas

cantHerramientas :: Ninja -> Number
cantHerramientas = sum . map snd . herramientas 

-- Funcion B
usarHerramienta :: Herramienta -> Ninja -> Ninja
usarHerramienta herramienta = herramientasSegunF (herramientasSin herramienta)

herramientasSin :: Herramienta -> [Herramienta] -> [Herramienta]
herramientasSin herramienta = filter (herramienta /=)

-- ------------ Parte B
-- Funcion A
esDesafiante :: Equipo -> Mision -> Bool
esDesafiante ninjas mision = algunoRangoMenor ninjas mision && muchosEnemigos mision

algunoRangoMenor :: Equipo -> Mision -> Bool
algunoRangoMenor ninjas mision = any (rangoEs (<) (rangoRecomendado mision)) ninjas

rangoEs :: (Number -> Number -> Bool) -> Number -> Ninja -> Bool
rangoEs op delta = (`op` delta) . rango

muchosEnemigos :: Mision -> Bool
muchosEnemigos = (>=2) . length . enemigos

-- Funcion B
esCopada :: Mision -> Bool
esCopada = cumpleCopada . recompensa

cumpleCopada :: Herramienta -> Bool
cumpleCopada herramienta = elem herramienta recompensasCopadas

recompensasCopadas :: [Herramienta]
recompensasCopadas = [("Bomba de Humo", 3) , ("Shuriken", 5), ("Kunai", 14)]

-- Funcion C
esFactible :: Equipo -> Mision -> Bool
esFactible ninjas mision = (not . esDesafiante ninjas) mision && estanPreparados ninjas mision

estanPreparados :: Equipo -> Mision -> Bool
estanPreparados ninjas mision = 
    cantNecesaria ninjas mision || armasSufic ninjas

armasSufic :: Equipo -> Bool
armasSufic = (>500) . sum . map cantHerramientas

cantNecesaria :: Equipo -> Mision -> Bool
cantNecesaria ninjas mision =  length ninjas >= cantNinjas mision

-- Funcion D
fallarMision :: Equipo -> Mision -> Equipo
fallarMision equipo mision = map (rangoSegunF (+2)) (ninjasRestantes mision equipo)

ninjasRestantes :: Mision -> Equipo -> Equipo
ninjasRestantes mision = filter (rangoEs (>=) (rangoRecomendado mision)) 

-- Funcion E
cumplirMision :: Mision -> Equipo -> Equipo
cumplirMision mision = map (cambiosPorCumplir mision) 

cambiosPorCumplir :: Mision -> Ninja -> Ninja
cambiosPorCumplir mision = rangoSegunF succ . obtenerHerramienta (recompensa mision) 

-- Funcion F
clonesDeSombra :: Number -> Jutsu
clonesDeSombra = cantNinjasSegunF . subtract

-- Funcion G
fuerzaDeUnCentenar :: Jutsu 
fuerzaDeUnCentenar = enemigosSegunF enemigosRestantes

enemigosRestantes :: [Ninja] -> [Ninja]
enemigosRestantes = filter (rangoEs (<=) 500)

-- Funcion H

ejecutarMision :: Equipo -> Mision -> Equipo
ejecutarMision equipo mision = completarMision (equipoUsaJutsus equipo mision) equipo

completarMision :: Mision -> Equipo -> Equipo
completarMision mision equipo 
    | esCopada mision || esFactible equipo mision = cumplirMision mision equipo 
    | otherwise = fallarMision equipo mision

equipoUsaJutsus :: Equipo -> Mision -> Mision
equipoUsaJutsus ninjas mision = foldl ninjaUsaJutsus mision (listaJutsus ninjas)

ninjaUsaJutsus :: Mision -> [Jutsu] -> Mision
ninjaUsaJutsus = foldl (\ m j -> j m) 

listaJutsus :: Equipo -> [[Jutsu]]
listaJutsus = map jutsus

{-
OTRA IMPLEMENTACION:

usarTodosSusJutsus :: Equipo -> Mision -> Mision
usarTodosSusJutsus unEquipo unaMision = foldr ($) unaMision . concatMap jutsus $ unEquipo
-}

-- ------------ Parte C
abanicoMadaraUchiha :: Herramienta 
abanicoMadaraUchiha = ("Abanico Madara Uchiha", 1)

zetsu :: Ninja
zetsu = UnNinja "Zetsu " [] [] 600

granGuerraNinja = UnaMision 100000 100 (infinitosEnemigos zetsu 1) abanicoMadaraUchiha

infinitosEnemigos :: Ninja -> Number -> [Ninja]
infinitosEnemigos ninja n = agregarSufijo (show n) ninja : infinitosEnemigos zetsu (n+1)

agregarSufijo :: String -> Ninja -> Ninja
agregarSufijo sufijo ninja = ninja {nombre = nombre ninja ++ sufijo}

{-
OTRA IMPLEMENTACION:

granGuerraNinja :: Mision
granGuerraNinja = Mision {
  cantidadDeNinjas = 100000,
  rangoRecomendado = 100,
  ninjasEnemigos   = infinitosZetsus,
  recompensa       = ("Honor", 1)
}

infinitosZetsus :: [Ninja]
infinitosZetsus = map zetsu [1..]

zetsu :: Int -> Ninja
zetsu unNumero = Ninja {
  nombre       = "Zetsu " ++ show unNumero,
  rango        = 600,
  jutsus       = [],
  herramientas = []
}

-}