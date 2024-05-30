module Library where
import PdePreludat
import GHC.Num (Num)
import System.Mem (performGC)

doble :: Number -> Number
doble numero = numero + numero

--PARTE 1: ¿Que es un alfajor?
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

--i) el coeficiente de dulzor de un alfajor: indica cuánto dulzor por gramo tiene el alfajor; 
--se calcula dividiendo su dulzor sobre su peso.
coeficienteDulzor :: Alfajor -> Number
coeficienteDulzor alfajor = dulzor alfajor / peso alfajor

--ii) el precio de un alfajor: se calcula como el doble de su peso sumado a la sumatoria de los precios
--de sus rellenos. Una capa de relleno de dulce de leche cuesta $12; una de mousse, $15; una de fruta, $10.
precioAlfajor :: Alfajor -> Number
precioAlfajor alfajor = doble (peso alfajor) + precioRellenos alfajor

precioCapa :: String -> Number
precioCapa capa
    |capa == "dulce de leche" = 12
    |capa == "mousse"= 15
    |capa == "fruta" = 10

precioRellenos :: Alfajor -> Number
precioRellenos alfajor = sum (map precioCapa (capas alfajor))

{-
iii) si un alfajor es potable: lo es si tiene al menos una capa de relleno 
(¿dónde se ha visto un alfajor sin relleno?), todas sus capas son del mismo sabor, 
y su coeficiente de dulzor es mayor o igual que 0,1.
-}

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

--PARTE 2: escalabilidad vertical
{-
Nos notificaron desde el kiosco que abrieron una planta de producción, en la cual comenzaron a experimentar sobre (o modificar) 
alfajores existentes, para tener más variedad. Nuestro software debería poder reflejar las siguientes modificaciones:
-}
--a) abaratar un alfajor: reduce su peso en 10g y su dulzor en 7. 
abaratarAlfajor :: Alfajor -> Alfajor
abaratarAlfajor = reducirDulzor . reducirPeso

reducirPeso :: Alfajor -> Alfajor
reducirPeso alfajor = alfajor {peso = peso alfajor - 10}

reducirDulzor :: Alfajor -> Alfajor
reducirDulzor alfajor = alfajor {dulzor = dulzor alfajor - 7}

--b)renombrar un alfajor, que cambia su packaging dándole un nombre completamente nuevo.
renombrarAlfajor :: String -> Alfajor -> Alfajor
renombrarAlfajor nuevoNombre alfajor = alfajor {nombre = nuevoNombre}

--c) agregar una capa de cierto relleno a un alfajor.
agregarCapa :: String -> Alfajor -> Alfajor
agregarCapa capa alfajor = alfajor {capas = capa : capas alfajor}

{-
d) hacer premium a un alfajor: dado un alfajor, le agrega una capa de relleno (del mismo tipo de relleno que ya tiene), 
y lo renombra a su nombre original + la palabra "premium" al final. Sólo los alfajores potables pueden hacerse premium; 
si se intenta hacer premium un alfajor no potable, el alfajor queda exactamente igual que como estaba.
-}
type Modificacion = Alfajor -> Alfajor

alfajorPremium :: Alfajor -> Alfajor
alfajorPremium alfajor 
    |alfajorPotable' alfajor = agregarCapaPremium . nombrePremium $ alfajor
    |otherwise = alfajor

nombrePremium :: Alfajor -> Alfajor
nombrePremium alfajor = alfajor {nombre = nombre alfajor ++ " " ++  "Premium"}

agregarCapaPremium :: Alfajor -> Alfajor
agregarCapaPremium alfajor = agregarCapa (head(capas alfajor)) alfajor

--e) hacer premium de cierto grado a un alfajor: consiste en hacerlo premium varias veces. 
--Este punto puede ser resuelto usando recursividad.
-- aplicarNveces :: Number -> Modificacion -> Alfajor -> Alfajor
-- aplicarNveces cantidad modificacion alfajor
--     |cantidad > 0 = aplicarNveces (cantidad -1) modificacion alfajor
--     |otherwise = alfajor

aplicarNveces :: Number -> Modificacion -> Alfajor -> Alfajor
aplicarNveces cantidad modificacion alfajor
    | cantidad > 0 = aplicarNveces (cantidad - 1) modificacion (modificacion alfajor)
    | otherwise = alfajor

alfajorNpremium :: Number -> Modificacion -> Alfajor -> Alfajor
alfajorNpremium = aplicarNveces

--f) Modelar los siguientes alfajores:
{-
i)Jorgitito, que es un Jorgito abaratado, y cuyo nombre es “Jorgitito”.

    abaratarAlfajor . renombrarAlfajor "jorgitito" $ jorgito

    Alfajor {capas = ["dulce de leche"], peso = 70, dulzor = 1, nombre = "jorgitito"}
-}

{-
ii) Jorgelín, que es un Jorgito pero con una capa extra de dulce de leche, y cuyo nombre es “Jorgelín”.

    agregarCapaPremium (renombrarAlfajor "Jorgelin" jorgito)

    Alfajor {capas = ["dulce de leche","dulce de leche"], peso = 80, dulzor = 8, nombre = "Jorgelin"}
-}

{-
iii) Capitán del espacio de costa a costa: es un capitán del espacio abaratado, luego hecho premium 
de grado 4, y luego renombrado a “Capitán del espacio de costa a costa”.

    renombrarAlfajor "Capitan del espacio de costa a costa" (alfajorNpremium 4 alfajorPremium (abaratarAlfajor capitanDelEspacio))

    Alfajor {capas = ["dulce de leche","dulce de leche","dulce de leche","dulce de leche","dulce de leche"], peso = 30, dulzor = 5, 
    nombre = "Capitan del espacio de costa a costa"}
-}

--PARTE 3
{-
Queremos también representar a los clientes de nuestro kiosco y registrar cuánto dinero tienen para gastar y qué alfajores nos compraron.
Sobre gustos no hay nada escrito. Cada cliente tiene diferentes criterios respecto a los alfajores. A un cliente le gusta un alfajor si
cumple con todos sus criterios.
-}
type Criterio = Alfajor -> Bool
type Criterios = [Criterio]
type Alfajores = [Alfajor]

data Cliente = Cliente {
    nombreCliente :: String, 
    dinero :: Number, 
    criterios :: Criterios, 
    alfajores :: Alfajores
}deriving Show

emi :: Cliente
emi = Cliente "Emi" 120 [soloMarca "Capitan del espacio"] []

tomi :: Cliente
tomi = Cliente "Tomi" 100 [pretencioso , dulcero] []

dante :: Cliente
dante = Cliente "Dante" 200 [sinRelleno "dulce de leche" , extraño] []

juan :: Cliente
juan = Cliente "Juan" 500 [soloMarca "Jorgito" , pretencioso, sinRelleno "mousse"] []



soloMarca :: String -> Criterio
soloMarca marca alfajor = contieneSubcadena marca (nombre alfajor)

contieneSubcadena :: String -> String -> Bool
contieneSubcadena subcadena cadena
    |length subcadena > length cadena = False
    |take (length subcadena) cadena == subcadena = True
    |otherwise = False

pretencioso :: Criterio
pretencioso alfajor = contieneSubcadena "Premium" (nombre alfajor)

sinRelleno :: String -> Criterio 
sinRelleno relleno alfajor = relleno `notElem` capas alfajor

dulcero :: Criterio
dulcero alfajor = coeficienteDulzor alfajor > 0.15

extraño :: Criterio
extraño = not . alfajorPotable'

--b) indicar, dada una lista de alfajores, cuáles le gustan a cierto cliente.
cualesLesGusta :: Alfajores -> Cliente -> Alfajores
cualesLesGusta alfajores cliente = lesGusta alfajores (criterios cliente)

lesGusta :: Alfajores -> Criterios -> Alfajores
lesGusta alfajores gustos = filter (cumplenConLosGustos gustos) alfajores

cumplenConLosGustos :: Criterios -> Alfajor -> Bool
cumplenConLosGustos criterios alfajor = all (\gustoPersonal -> gustoPersonal alfajor) criterios

--c. que un cliente pueda comprar un alfajor: esto lo agrega a su lista de alfajores actuales, 
--y gasta el dinero correspondiente al precio del alfajor. Si no tiene suficiente plata, no lo compra y queda como está.

comprarAlfajor :: Alfajor -> Cliente -> Cliente
comprarAlfajor alfajor cliente
    |dinero cliente >= precioAlfajor alfajor = agregarAlfajor alfajor (restarDinero alfajor cliente)
    |otherwise = cliente

agregarAlfajor :: Alfajor -> Cliente -> Cliente
agregarAlfajor alfajor cliente = cliente {alfajores = alfajor : alfajores cliente}

restarDinero :: Alfajor -> Cliente -> Cliente
restarDinero alfajor cliente = cliente {dinero = dinero cliente - precioAlfajor alfajor}

--d. que un cliente compre, de una lista de alfajores, todos aquellos que le gustan.
comprarDeLista :: Alfajores -> Cliente -> Cliente
comprarDeLista alfajores cliente = comprarAlfajores cliente (cualesLesGusta alfajores cliente)

comprarAlfajores :: Cliente -> Alfajores-> Cliente
comprarAlfajores = foldl (flip comprarAlfajor)