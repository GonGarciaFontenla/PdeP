module Library where
import PdePreludat
import GHC.Num (Num)
import System.Mem (performGC)

doble :: Number -> Number
doble numero = numero + numero

{-
Las fuerzas rebeldes analizan diferentes estrategias para enfrentarse a las naves espaciales imperiales de Darth Vader. 
Debido a los bajos números de la resistencia decidieron que por cada flota enemiga van a enviar a una única nave para
llevar adelante misiones sorpresa. Para ello, decidieron hacer un programa en Haskell Espacial que les permita planificar 
adecuadamente la lucha contra el lado oscuro simulando estos combates.
De todas las naves conociendo su durabilidad, su ataque, su escudo y su poder especial. A modo de ejemplo se presentan algunas: 
-}

type Poder = Nave -> Nave  
type Poderes = [Poder]

data Nave = Nave {
    nombre :: String, 
    durabilidad :: Number, 
    escudo :: Number, 
    ataque :: Number,
    poder :: Poder
}

tiefigther :: Nave
tiefigther = Nave "TIE-Figther" 200 100 50 movimientoTurbo

xwing :: Nave
xwing = Nave "X-Wing" 300 150 100 reparacionEmergencia

naveDarthVader :: Nave
naveDarthVader = Nave "Nave de Darth Vader" 500 300 200 movimientoSuperTurbo

millenniumFalcon :: Nave
millenniumFalcon = Nave "Millennium Falcon" 1000 500 50 reparacionEmergencia'


movimientoTurbo :: Nave -> Nave
movimientoTurbo = modificarAtaque 30

reparacionEmergencia :: Nave -> Nave
reparacionEmergencia nave = modificarAtaque (-30) (reducirDurabilidad 50 nave)

movimientoSuperTurbo :: Nave -> Nave
movimientoSuperTurbo nave = aplicarNveces 3 movimientoTurbo (reducirDurabilidad 45 nave)

reparacionEmergencia' :: Nave -> Nave
reparacionEmergencia' = reparacionEmergencia . incrementarEscudo 100

modificarAtaque :: Number -> Nave -> Nave
modificarAtaque valor nave = nave {ataque = ataque nave + valor}

reducirDurabilidad :: Number -> Nave -> Nave
reducirDurabilidad valor nave = nave {durabilidad = durabilidad nave - valor}

aplicarNveces :: Number -> Poder -> Nave -> Nave
aplicarNveces cantidad poder nave
    |cantidad >= 0 = aplicarNveces (cantidad - 1) poder nave
    |otherwise = nave

incrementarEscudo :: Number -> Nave -> Nave
incrementarEscudo valor nave = nave {escudo = escudo nave + valor}
