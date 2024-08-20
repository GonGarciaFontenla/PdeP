--enunciado: https://docs.google.com/document/d/1ULbIycNlP8XNz9qgvECuw2rsLv2_cay30jcpR-OB6jQ/edit#heading=h.bzijjzpynqq4

import Text.Show.Functions () 
import Data.List(genericLength, intersect)

--Punto 1
data Auto = Auto {
    marca :: String,
    modelo :: String,
    desgaste :: Desgaste,
    velocidadMaxima :: Float, --m/s
    tiempoCarrera :: Float
} deriving (Show, Eq)

type Desgaste = (Ruedas, Chasis)

type Ruedas = Float

type Chasis = Float

desgasteRuedas :: (Ruedas , Chasis) -> Ruedas
desgasteRuedas = fst

desgasteChasis :: (Ruedas , Chasis) -> Chasis
desgasteChasis = snd

ferrari :: Auto
ferrari = Auto {
    marca = "Ferrari",
    modelo = "F50",
    desgaste = (0 , 0),
    velocidadMaxima = 65,
    tiempoCarrera = 0
}

lamborghini :: Auto
lamborghini = Auto {
    marca = "Lamborghini",
    modelo = "Diablo",
    desgaste = (3 , 7),
    velocidadMaxima = 73,
    tiempoCarrera = 0
}

fiat :: Auto
fiat = Auto {
    marca = "Fiat",
    modelo = "600",
    desgaste = (27 , 33),
    velocidadMaxima = 44,
    tiempoCarrera = 0
}

--Punto 2
estaEnBuenEstado :: Auto -> Bool
estaEnBuenEstado auto = (desgasteRuedas . desgaste) auto < 60 && (desgasteChasis . desgaste) auto < 40

noDaMas :: Auto -> Bool
noDaMas auto = (desgasteRuedas . desgaste) auto > 80 || (desgasteChasis . desgaste) auto > 80

--Punto 3
reparar :: Auto -> Auto
reparar = modificarDesgasteChasis (*0.15) . cambiarRuedas

modificarDesgasteChasis :: (Float -> Float) -> Auto -> Auto
modificarDesgasteChasis f auto = auto {desgaste = (desgasteRuedas . desgaste $ auto , (f . desgasteChasis . desgaste) auto )}

modificarDesgasteRuedas :: (Float -> Float) -> Auto -> Auto
modificarDesgasteRuedas f auto = auto {desgaste = ((f . desgasteRuedas . desgaste) auto  , desgasteChasis . desgaste $ auto)}

cambiarRuedas :: Auto -> Auto
cambiarRuedas auto = modificarDesgasteRuedas (flip (-) (desgasteRuedas . desgaste $ auto)) auto

--Punto 4
type Tramo = Auto -> Auto

type Curva = Tramo

curva :: Float -> Float -> Tramo
curva angulo longitud auto = modificarDesgasteRuedas (+ (3 * longitud / angulo)) . sumarTiempo (longitud / (velocidadMaxima auto / 2)) $ auto

sumarTiempo :: Float -> Auto -> Auto
sumarTiempo segundos auto = auto {tiempoCarrera = tiempoCarrera auto + segundos}

curvaPeligrosa :: Curva
curvaPeligrosa = curva 60 300

curvaTranca :: Curva
curvaTranca = curva 110 550

type Recta = Tramo

recta :: Float -> Recta
recta longitud auto = modificarDesgasteChasis (+ (longitud / 100)) . sumarTiempo (longitud / velocidadMaxima auto) $ auto

tramoRectoClassic :: Recta
tramoRectoClassic = recta 750

tramito :: Recta
tramito = recta 280

boxes :: Tramo -> Tramo
boxes tramo auto
    | estaEnBuenEstado auto = tramo auto
    | otherwise = sumarTiempo 10 . tramo . reparar $ auto

parteMojada :: Tramo -> Tramo
parteMojada tramo auto = sumarTiempo (0.5 * tiempoAgregadoPorTramo tramo auto) . tramo $ auto

tiempoAgregadoPorTramo :: Tramo -> Auto -> Float
tiempoAgregadoPorTramo tramo auto = tiempoCarrera (tramo auto) - tiempoCarrera auto

ripio :: Tramo -> Tramo
ripio tramo = tramo . tramo

parteObstruida :: Float -> Tramo -> Tramo
parteObstruida longitudObstruida tramo = modificarDesgasteRuedas (+ (2 * longitudObstruida)) . tramo

--Punto 5
pasarPorTramo :: Tramo -> Auto -> Auto
pasarPorTramo tramo auto
    | not . noDaMas $ auto = tramo auto
    | otherwise = auto

--Punto 6
type Pista = [Tramo]

superPista :: Pista
superPista = [tramoRectoClassic, curvaTranca, parteMojada tramito, tramito, parteObstruida 2 (curva 80 400), curva 115 650, recta 970, curvaPeligrosa, ripio tramito, boxes (recta 800)]

peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta pista = filter (not . noDaMas) . map (pasarPorTramo . vueltaPista $ pista)

vueltaPista :: Pista -> Tramo
vueltaPista = foldl (.) id

--Punto 7
data Carrera = Carrera {
    pista :: Pista,
    vueltas :: Int
}

tourBuenosAires :: Carrera
tourBuenosAires = Carrera {
    pista = superPista,
    vueltas = 20
}

correrUnaCarrera :: Carrera -> [Auto] -> [[Auto]]
correrUnaCarrera carrera autos = take (vueltas carrera) (iterate (peganLaVuelta (pista carrera)) autos)
