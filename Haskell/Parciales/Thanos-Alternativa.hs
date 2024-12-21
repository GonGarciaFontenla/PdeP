module Library where
import PdePreludat
import Prelude (Foldable(foldMap))
import Test.Hspec (xcontext)

doble :: Number -> Number
doble numero = numero + numero

type Habilidad = String
type Habilidades = [Habilidad]
type Planeta = String 
type Universo = [Personaje]
type Gema = Personaje -> Personaje
type Gemas = [Gema]

data Guantelete = Guantelete {
    material :: String, 
    gemas :: Gemas
}deriving (Eq, Show)

data Personaje = Personaje {
    edad :: Number, 
    energia :: Number, 
    habilidades :: Habilidades,
    nombre :: String, 
    planeta :: Planeta 
}deriving (Eq, Show)

ironMan :: Personaje
ironMan = Personaje 48 50 ["Volar", "Tecnologia avanzada", "Armadura"] "Iron Man" "Tierra"

drStrange :: Personaje
drStrange = Personaje 45 95 ["Magia", "Manipulacion del tiempo", "Hechiceria"] "Dr. Strange" "Tierra"

groot :: Personaje
groot = Personaje 25 80 ["Regeneracion", "Fuerza sobrehumana", "Comunicacion vegetal"] "Groot" "Planeta X"

wolverine :: Personaje
wolverine = Personaje 200 90 ["Regeneracion", "Garras de adamantium", "Sentidos agudizados"] "Wolverine" "Tierra"

catWoman :: Personaje
catWoman = Personaje 35 85 ["Agilidad", "Sigilo", "Combate cuerpo a cuerpo"] "Cat Woman" "Tierra"

chasquearUniverso :: Guantelete -> Universo -> Universo
chasquearUniverso guantelete universo
    |esCompleto guantelete = reducirHabitantes (mitadHabitantes universo) universo
    |otherwise = universo

reducirHabitantes :: Number -> Universo -> Universo
reducirHabitantes =  take  

mitadHabitantes :: Universo -> Number
mitadHabitantes universo = div (length universo) 2

esCompleto :: Guantelete -> Bool
esCompleto guantelete = tieneTodasLasGemas guantelete && hechoDeUru guantelete 

tieneTodasLasGemas :: Guantelete -> Bool
tieneTodasLasGemas = (==6) . length . gemas

hechoDeUru :: Guantelete -> Bool
hechoDeUru guantelete = material guantelete == "uru"

aptoPendex :: Universo -> Bool
aptoPendex = existeJoven 

existeJoven :: Universo -> Bool
existeJoven = any menorA45 

menorA45 :: Personaje -> Bool
menorA45  personaje = edad personaje < 45

energiaTotal :: Universo -> Number
energiaTotal = sum . map energia . habilidosos

habilidosos :: Universo -> Universo
habilidosos  = filter masDeUnaHabilidad

masDeUnaHabilidad :: Personaje -> Bool 
masDeUnaHabilidad = (>1) . length . habilidades

------------------Parte 2------------------
mente :: Number -> Gema
mente = modificarEnergia 

alma :: Habilidad -> Gema
alma habilidad = modificarEnergia 10 . eliminarHabilidad habilidad 

espacio :: Planeta -> Gema
espacio planeta = modificarEnergia 20 . modificarPlaneta planeta

tiempo :: Gema
tiempo = modificarEnergia 50 . reducirEdad  

loca :: Gema -> Gema
loca gema = gema . gema 

modificarEnergia :: Number -> Personaje -> Personaje
modificarEnergia cant personaje = personaje {energia = energia personaje - cant}

eliminarHabilidad :: Habilidad -> Personaje -> Personaje
eliminarHabilidad habilidad personaje 
    |tieneHabilidad habilidad personaje = quitarHabilidad habilidad personaje
    |otherwise = personaje

tieneHabilidad :: Habilidad -> Personaje -> Bool
tieneHabilidad habilidad  = elem habilidad . habilidades 

quitarHabilidad :: Habilidad -> Personaje -> Personaje
quitarHabilidad habilidad personaje = personaje {habilidades = sacarHabilidad habilidad personaje}

sacarHabilidad :: Habilidad -> Personaje -> Habilidades
sacarHabilidad habilidad  = filter (habilidad /=) . habilidades 

modificarPlaneta :: Planeta -> Personaje -> Personaje
modificarPlaneta planet personaje = personaje {planeta = planet}

reducirEdad :: Personaje -> Personaje
reducirEdad personaje = personaje {edad = max 18 (mitadEdad personaje)}

mitadEdad :: Personaje -> Number
mitadEdad personaje = edad personaje `div` 2

utilizar :: Personaje -> Gemas -> Personaje
utilizar = foldr ($) 

{-
Punto 6: (2 puntos). Resolver utilizando recursividad. Definir la función
gemaMasPoderosa que dado un guantelete y una persona obtiene la gema del infinito que
produce la pérdida más grande de energía sobre la víctima.
-}

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete = evaluarPoderGemas (gemas guantelete) 

evaluarPoderGemas :: Gemas -> Personaje -> Gema
evaluarPoderGemas [x] _ = x
evaluarPoderGemas (x:y:xs) personaje = evaluarPoderGemas (masPoderosa x y personaje:xs) personaje

masPoderosa :: Gema -> Gema -> Personaje ->  Gema 
masPoderosa g1 g2 personaje
    |produceMasPerdida g1 g2 personaje = g1
    |otherwise = g2

produceMasPerdida :: Gema -> Gema -> Personaje -> Bool
produceMasPerdida g1 g2 p = energia (g1 p) <= energia (g2 p)