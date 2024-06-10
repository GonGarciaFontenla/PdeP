--resolucion parcial Alfajores PdeP
--enunciado: https://docs.google.com/document/d/1m8gRD-gheA2fDbiDXc7-dpiymkhDQRbmzr-plL5BGuA/edit

import Text.Show.Functions
import Data.List(genericLength)
import Data.List(isInfixOf)

--PUNTO 1

data Alfajor = Alfajor {
    rellenos :: [Relleno],
    peso :: Float, --gramos
    dulzor :: Float,
    nombre :: String
} deriving (Show, Eq)

data Relleno = Relleno {
    nombreRelleno :: String,
    precioRelleno :: Float
} deriving (Show, Eq)

dulceDeLeche :: Relleno
dulceDeLeche = Relleno {
    nombreRelleno = "Dulce de Leche",
    precioRelleno = 12
}

mousse :: Relleno
mousse = Relleno {
    nombreRelleno = "Mousse",
    precioRelleno = 15
}

fruta :: Relleno
fruta = Relleno {
    nombreRelleno = "Fruta",
    precioRelleno = 15
}

--a)
jorgito :: Alfajor
jorgito = Alfajor {
    rellenos = [dulceDeLeche],
    peso = 80,
    dulzor = 8,
    nombre = "Jorgito"
}

havanna :: Alfajor
havanna = Alfajor {
    rellenos = [mousse, mousse],
    peso = 60,
    dulzor = 12,
    nombre = "Havanna"
}

capitanDelEspacio :: Alfajor
capitanDelEspacio = Alfajor {
    rellenos = [dulceDeLeche],
    peso = 40,
    dulzor = 12,
    nombre = "Capitán del espacio"
}

--b)
coeficienteDulzor :: Alfajor -> Float
coeficienteDulzor alfajor = dulzor alfajor / peso alfajor

precioAlfajor :: Alfajor -> Float
precioAlfajor alfajor = 2 * peso alfajor + precioSoloRelleno alfajor

precioSoloRelleno :: Alfajor -> Float
--precioSoloRelleno alfajor = sum (map precioRelleno (rellenos alfajor))
precioSoloRelleno  = sum . map precioRelleno . rellenos

alfajorPotable :: Alfajor -> Bool
alfajorPotable alfajor = cantidadDeCapas alfajor > 1 && capasMismoSabor alfajor && coeficienteDulzor alfajor >= 0.1

cantidadDeCapas :: Alfajor -> Int
cantidadDeCapas  = genericLength . rellenos

capasMismoSabor :: Alfajor -> Bool
capasMismoSabor (Alfajor [] _ _ _) = False
capasMismoSabor alfajor = all (== head (rellenos alfajor)) (tail (rellenos alfajor))

--PUNTO 2
type Modificacion = Alfajor -> Alfajor

--a
abaratar :: Modificacion
abaratar  = cambiarDulzor (flip (-) 7) . cambiarPeso (flip (-) 10)

cambiarPeso :: (Float -> Float) -> Modificacion
cambiarPeso funcion alfajor = alfajor {peso = funcion (peso alfajor)}

cambiarDulzor :: (Float -> Float) -> Modificacion
cambiarDulzor funcion alfajor = alfajor {dulzor = funcion (dulzor alfajor)}

--cambiarValorNumerico :: (Alfajor -> Float) -> (Float -> Float) -> Alfajor -> Alfajor
--cambiarValorNumerico pesoODulzor funcion alfajor = alfajor {pesoODulzor = funcion (pesoODulzor alfajor)}

--b
renombrar :: String -> Modificacion
renombrar nombreNuevo alfajor = alfajor {nombre = nombreNuevo}

--c
agregarCapa :: Relleno -> Modificacion
agregarCapa rellenoNuevo alfajor = alfajor {rellenos = rellenoNuevo : rellenos alfajor}

--d
hacerPremium :: Modificacion
hacerPremium alfajor
    | alfajorPotable alfajor = agregarCapa (head (rellenos alfajor)) . renombrar (nombre alfajor ++ " premium") $ alfajor
    | otherwise = alfajor

--e
hacerPremiumNVeces :: Int -> Modificacion
hacerPremiumNVeces veces alfajor
    | veces == 1 = hacerPremium alfajor
    | otherwise = hacerPremiumNVeces (veces - 1) . hacerPremium $ alfajor

--f
jorgitito :: Alfajor
jorgitito = renombrar "Jorgitito" . abaratar $ jorgito

jorgelin :: Alfajor
jorgelin = agregarCapa dulceDeLeche . renombrar "Jorgelin" $ jorgito

capitanDelEspacioDeCostaACosta :: Alfajor
capitanDelEspacioDeCostaACosta = renombrar "Capitán del espacio de costa a costa" . hacerPremiumNVeces 4 . abaratar $ capitanDelEspacio

--PUNTO 3
type Criterio = Alfajor -> Bool

data Cliente = Cliente {
    nombreCliente :: String,
    criterios :: [Criterio],
    dinero :: Float,
    alfajoresComprados :: [Alfajor]
}

emi :: Cliente
emi = Cliente {
    nombreCliente = "Emi",
    criterios = [buscaMarcaOCalidad "Capitán del espacio"],
    dinero = 120,
    alfajoresComprados = []
}

buscaMarcaOCalidad :: String -> Criterio
buscaMarcaOCalidad marcaOCalidad alfajor = marcaOCalidad `isInfixOf` nombre alfajor

tomi :: Cliente
tomi = Cliente {
    nombreCliente = "Tomi",
    criterios = [pretencioso, dulcero],
    dinero = 100,
    alfajoresComprados = []
}

pretencioso :: Criterio
pretencioso = buscaMarcaOCalidad "premium"

dulcero :: Criterio
dulcero = (>0.15) . coeficienteDulzor

dante :: Cliente
dante = Cliente {
    nombreCliente = "Dante",
    criterios = [anti dulceDeLeche, extraño],
    dinero = 200,
    alfajoresComprados = []
}

anti :: Relleno -> Criterio
anti relleno alfajor = not (any (==relleno) (rellenos alfajor))

extraño :: Criterio
extraño = not . alfajorPotable

juan :: Cliente
juan = Cliente {
    nombreCliente = "Juan",
    criterios = [dulcero, buscaMarcaOCalidad "Jorgito", pretencioso, anti mousse],
    dinero = 500,
    alfajoresComprados = []
}

cualesGustan :: Cliente -> [Alfajor] -> [Alfajor]
cualesGustan cliente listaAlfajores = filter (cumpleCriterios cliente) listaAlfajores

cumpleCriterios :: Cliente -> Alfajor -> Bool
cumpleCriterios cliente alfajor = all ($ alfajor) (criterios cliente)

comprarAlfajor :: Cliente -> Alfajor -> Cliente
comprarAlfajor cliente alfajor
    | dinero cliente > precioAlfajor alfajor = agregarAlfajor (gastarDinero cliente alfajor) alfajor
    | otherwise = cliente

agregarAlfajor :: Cliente -> Alfajor -> Cliente
agregarAlfajor cliente alfajor = cliente {alfajoresComprados = alfajor : alfajoresComprados cliente}

gastarDinero :: Cliente -> Alfajor -> Cliente
gastarDinero cliente alfajor = cliente {dinero = dinero cliente - precioAlfajor alfajor}

comprarLosQueGustan :: Cliente -> [Alfajor] -> Cliente
comprarLosQueGustan cliente listaAlfajores = foldl comprarAlfajor cliente (cualesGustan cliente listaAlfajores)