module Library where
import PdePreludat
import GHC.Num (Num)
import System.Mem (performGC)

doble :: Number -> Number
doble numero = numero + numero

--PARTE 1
data Alfajor = Alfajor {
    capas :: [String],
    peso :: Number,
    dulzor :: Number,
    nombre :: String
}deriving Show

jorgito :: Alfajor
jorgito = Alfajor ["dulce de leche"] 80 8 "Jorgito"

havanna :: Alfajor
havanna = Alfajor ["mousse", "mousse"] 60 12 "Havanna"

capitanDelEspacio :: Alfajor
capitanDelEspacio = Alfajor ["dulce de leche"] 40 12 "Capitan del espacio"

coeficienteDulzor :: Alfajor -> Number
coeficienteDulzor alfajor = dulzor alfajor / peso alfajor

precioAlfajor :: Alfajor -> Number
precioAlfajor alfajor = doble (peso alfajor) + precioRellenos alfajor

precioCapa :: String -> Number
precioCapa capa
    |capa == "dulce de leche" = 12
    |capa == "mousse"= 15
    |capa == "fruta" = 10

precioRellenos :: Alfajor -> Number
precioRellenos alfajor = sum (map precioCapa (capas alfajor))

--Solucion aplicando recursividad
--La consigna aclara que no se debe usar salvo que se pida en la consiga. 
alfajorPotable :: Alfajor -> Bool
alfajorPotable alfajor = rellenoIgual (capas alfajor) && coeficienteMayor alfajor

rellenoIgual :: [String] -> Bool
rellenoIgual [] = False
rellenoIgual [x] = True
rellenoIgual (x:y:ys) = x == y && rellenoIgual (y:ys)

coeficienteMayor :: Alfajor -> Bool
coeficienteMayor alfajor = coeficienteDulzor alfajor > 0.1

--Solucion valida. 
alfajorPotable' :: Alfajor -> Bool
alfajorPotable' alfajor = mismoSabor (capas alfajor) && coeficienteMayor alfajor

mismoSabor :: [String] -> Bool
mismoSabor [] = False
mismoSabor capas = all (== head capas) (tail capas)

--PARTE 2