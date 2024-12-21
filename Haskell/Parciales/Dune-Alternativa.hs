module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

data Fremen = Fremen {
    nombre :: String, 
    tolerancia :: Number, 
    titulos :: [String],
    reconocimientos :: Number
}deriving(Eq,Show)

type Tribu = [Fremen]
type Operador = (Number -> Number -> Bool)

stilgar :: Fremen
stilgar = Fremen "Stilgar" 150 ["Guia"] 3

gonza :: Fremen 
gonza = Fremen "Gonza" 120 ["Domador"] 4

gustavo :: Fremen 
gustavo = Fremen "Gustavo" 120 ["Domador"] 5

santiago :: Fremen 
santiago = Fremen "Santiago" 120 ["Domador"] 6

----------------Parte 1---------------- 

recibirReconocimiento :: Fremen -> Fremen
recibirReconocimiento = sumarReconocimiento 

sumarReconocimiento :: Fremen -> Fremen
sumarReconocimiento fremen = fremen {reconocimientos = reconocimientos fremen + 1}

elElegido :: Tribu -> Fremen    
elElegido tribu = foldl1 maxReconocimiento (candidatosAelegido tribu)

maxReconocimiento :: Fremen -> Fremen -> Fremen
maxReconocimiento fremen1 fremen2 
    |mayorReconocimiento fremen1 fremen2 = fremen1
    |otherwise = fremen2

mayorReconocimiento :: Fremen -> Fremen -> Bool
mayorReconocimiento f1 f2 = reconocimientos f1 >= reconocimientos f2

candidatosAelegido :: Tribu -> Tribu
candidatosAelegido = filter cumpleElegido 

existeCandidatoAelegido :: Tribu -> Bool
existeCandidatoAelegido = any cumpleElegido  

cumpleElegido :: Fremen -> Bool
cumpleElegido fremen = esDomador fremen && esTolerante (>) fremen 100

esDomador :: Fremen -> Bool
esDomador fremen = "Domador" `elem` titulos fremen

esTolerante :: Operador -> Fremen -> Number -> Bool
esTolerante operador fremen cant = tolerancia fremen `operador` cant

----------------Parte 2---------------- 
data Gusano = Gusano {
    longitud :: Number, 
    hidratacion :: Number, 
    descripcion :: String
}deriving(Eq, Show)

type Gusanos = [Gusano]
gusano1, gusano2 :: Gusano

gusano1 = Gusano 10 5 "rojo con lunares"
gusano2 = Gusano 8 1 "dientes puntiagudos"

aparearGusanos :: Gusanos -> Gusanos -> Gusanos
aparearGusanos [] _ = []
aparearGusanos _ [] = []
aparearGusanos (x1:xs) (y1:ys) = aparear x1 y1 : aparearGusanos xs ys

aparear :: Gusano -> Gusano -> Gusano
aparear g1 g2 = Gusano (calcLong g1 g2) 0 (concatenarDesc g1 g2)

concatenarDesc :: Gusano -> Gusano -> String
concatenarDesc g1 g2 = descripcion g1 ++ "-" ++ descripcion g2

calcLong :: Gusano -> Gusano -> Number
calcLong g1 g2= longMax g1 g2 * 0.1

longMax :: Gusano -> Gusano -> Number
longMax g1 g2 = max (longitud g1) (longitud g2)


----------------Parte 3---------------- 
type Mision = Fremen -> Gusano -> Fremen
elegidoEvoluciona :: Mision -> Gusano -> Tribu -> Bool
elegidoEvoluciona mision gusano tribu = distintosFremen (mision (elElegido tribu) gusano) (elElegido tribu) 

distintosFremen :: Fremen -> Fremen -> Bool
distintosFremen fremen1 fremen2 = fremen1 /= fremen2

elegidoEvoluciona' :: Mision -> Gusano -> Tribu -> Bool
elegidoEvoluciona' mision gusano tribu = elElegido tribu /= elElegido (misionColectiva mision gusano tribu)

misionColectiva :: Mision -> Gusano -> Tribu -> Tribu
misionColectiva mision gusano = map (`mision` gusano)

domarGusano :: Mision
domarGusano fremen gusano 
    |puedeDomar fremen gusano = cambiosPorDomar fremen
    |otherwise = reducirTolerenciaPorPorcentaje 10 fremen

destruirGusano :: Mision
destruirGusano fremen gusano 
    |puedeDestruir fremen gusano = cambiosPorDestruir fremen
    |otherwise = reducirTolerenciaPorPorcentaje 20 fremen 

cambiosPorDomar :: Fremen -> Fremen
cambiosPorDomar = convertirseEnDomador . modificarTolerencia 100 

convertirseEnDomador :: Fremen -> Fremen
convertirseEnDomador fremen = fremen {titulos = "Domador": titulos fremen}

modificarTolerencia :: Number -> Fremen -> Fremen
modificarTolerencia cant fremen = fremen {tolerancia = tolerancia fremen + cant}

puedeDomar :: Fremen -> Gusano -> Bool
puedeDomar fremen gusano = esTolerante (>=) fremen (mitadLong gusano) 

calcValorPorcentaje :: Number -> Fremen -> Number
calcValorPorcentaje porcentaje fremen = -(tolerancia fremen * porcentaje/100)

puedeDestruir :: Fremen -> Gusano -> Bool
puedeDestruir fremen gusano = esDomador fremen && esTolerante (<) fremen (mitadLong gusano)

mitadLong :: Gusano -> Number
mitadLong = (/2).longitud 

cambiosPorDestruir :: Fremen -> Fremen
cambiosPorDestruir = recibirReconocimiento . modificarTolerencia 100 

reducirTolerenciaPorPorcentaje :: Number -> Fremen -> Fremen
reducirTolerenciaPorPorcentaje cant fremen = modificarTolerencia (calcValorPorcentaje 20 fremen) fremen