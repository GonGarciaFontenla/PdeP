module Library where
import PdePreludat


doble :: Number -> Number
doble numero = numero + numero

{-
    En el universo local de Harry Postre, para hacer postres se utilizan hechizos que se van usando sobre
    los mismos para irlos preparando.
-}

--Modelar los postres. Un mismo postre puede tener muchos sabores, tiene un peso y se sirve a cierta temperatura.

data Postre = Postre {
    nombre :: String,
    sabores :: [String],
    peso :: Number,
    temperatura :: Number
}deriving (Show, Eq)

bizcochoBorracho :: Postre
bizcochoBorracho = Postre "Bizcocho borracho" ["fruta" , "crema"] 100 25

tarta :: Postre
tarta = Postre "Tarta de melaza" ["melaza"] 50 1

--Modelar los hechizos, sabiendo que deberían poderse agregar más sin modificar el código existente.
type Hechizo = Postre -> Postre

incendio :: Hechizo
incendio = modificarTemperatura 1 . perderPorcentajePeso 5

inmobulus :: Hechizo
inmobulus postre = modificarTemperatura (-(temperatura postre)) postre

wingardiumLeviosa :: Hechizo
wingardiumLeviosa = agregarSabor "concentrado" . perderPorcentajePeso 10
 
diffindo ::Number -> Hechizo
diffindo = perderPorcentajePeso

riddikulus :: String -> Hechizo
riddikulus sabor = agregarSabor (reverse sabor)

avadaKedvra :: Hechizo
avadaKedvra = inmobulus . quitarSabores 

modificarTemperatura :: Number -> Postre -> Postre
modificarTemperatura temp postre = postre {temperatura = temperatura postre + temp}

perderPorcentajePeso :: Number -> Postre -> Postre
perderPorcentajePeso porcentaje postre = postre {peso = peso postre - ((peso postre * porcentaje)/100)}

agregarSabor :: String -> Postre -> Postre
agregarSabor saborNuevo postre = postre {sabores = saborNuevo : sabores postre}

quitarSabores :: Postre -> Postre
quitarSabores postre = postre {sabores = []}

{-
    Dado un conjunto de postres en la mesa, saber si hacerles un determinado hechizo los dejará 
    listos (un postre está listo cuando pesa algo más que cero, tiene algún sabor y además no está congelado).
-}
--Forma Recursiva
hechizoDejaListo :: Hechizo -> [Postre] -> Bool
hechizoDejaListo hechizo [x] = estaListo (hechizo x)
hechizoDejaListo hechizo (x:xs) = estaListo (hechizo x) && hechizoDejaListo hechizo xs

--Forma no recursiva 
hechizoDejaListo' :: Hechizo -> [Postre] -> Bool
hechizoDejaListo' hechizo = all (estaListo . hechizo)

estaListo :: Postre -> Bool
estaListo postre = peso postre > 0 && tieneSabores postre && not (estaCongelado postre)

tieneSabores :: Postre -> Bool
tieneSabores = not . null .sabores
--tieneSabores = (>0) . length . sabores

estaCongelado :: Postre -> Bool
estaCongelado = (<=0) . temperatura 

--Dado un conjunto de postres en la mesa, conocer el peso promedio de los postres listos.
promedioPeso :: [Postre] -> Number
promedioPeso = promedio . obtenerPesos 

promedio :: [Number] -> Number
promedio pesos = (/length pesos) (sum pesos)

postresListos :: [Postre] -> [Postre] 
postresListos = filter estaListo

obtenerPesos :: [Postre] -> [Number]
obtenerPesos postres = map peso (postresListos postres)

--De un mago se conocen sus hechizos aprendidos y la cantidad de horrorcruxes que tiene.
type Hechizos = [Hechizo]

data Mago = Mago {
    nombre_mago :: String, 
    hechizos :: Hechizos,
    horrorcruxes :: Number
}deriving Show

harry :: Mago
harry = Mago "Harry" [incendio, wingardiumLeviosa] 0
{-
    Hacer que un mago asista a la clase de defensa contra las cocinas oscuras y practique con un 
    hechizo sobre un postre (se espera obtener el mago). Cuando un mago practica con un hechizo, 
    lo agrega a sus hechizos aprendidos. 
    Además si el resultado de usar el hechizo en el postre es el mismo que aplicarle “avada 
    kedavra” al postre, entonces suma un horrorcrux.
-}
practicarHechizo :: Hechizo -> Postre -> Mago -> Mago
practicarHechizo hechizo postre = agregarHorrorcrux hechizo postre . agregarHechizo hechizo

agregarHorrorcrux :: Hechizo -> Postre -> Mago -> Mago
agregarHorrorcrux hechizo postre mago
    |mismoEfectoAvada hechizo postre = sumarHorrorcrux mago
    |otherwise = mago

agregarHechizo :: Hechizo -> Mago -> Mago 
agregarHechizo hechizo mago = mago {hechizos = hechizo : hechizos mago} 

mismoEfectoAvada :: Hechizo -> Postre -> Bool
mismoEfectoAvada hechizo postre = hechizo postre == avadaKedvra postre
--mismoEfectoAvada hechizo postre = not (tieneSabores (hechizo postre)) && estaCongelado (hechizo postre)

sumarHorrorcrux :: Mago -> Mago
sumarHorrorcrux mago = mago {horrorcruxes = horrorcruxes mago + 1}

{-
    Dado un postre y un mago obtener su mejor hechizo, que es aquel de sus hechizos que deja al 
    postre con más cantidad de sabores luego de usarlo.
-}

{-
Creo que esta solucion no funca --> No hay manera de recuperar el hechizo
La dejo por si alguien quiere intentar.

    mejorHechizo :: Postre -> Mago -> Number
    mejorHechizo postre mago = maximum (cantidadSaboresLuegoHechizo postre (hechizos mago))

    cantidadSaboresLuegoHechizo :: Postre -> Hechizos -> [Number]
    cantidadSaboresLuegoHechizo postre = map (length . sabores . ($ postre)) 
-}

mejorHechizo :: Postre -> Mago -> Hechizo
mejorHechizo postre mago = elMejor postre (hechizos mago)

elMejor :: Postre -> Hechizos -> Hechizo
elMejor _ [x] = x
elMejor postre (x:y:ys)
    |esMejor postre x y = elMejor postre (x:ys) 
    |otherwise = elMejor postre (y:ys) 

esMejor :: Postre -> Hechizo -> Hechizo -> Bool
esMejor postre hechizo1 hechizo2 = (length . sabores . hechizo1) postre > (length . sabores . hechizo2) postre

--Version con fold
mejorHechizo' :: Postre -> Mago -> Hechizo
mejorHechizo' postre mago = foldl1 (esMejorEntre postre) (hechizos mago) --Agarra como semilla al primero de la lista

esMejorEntre :: Postre -> Hechizo -> Hechizo -> Hechizo
esMejorEntre postre hechizo1 hechizo2
    |esMejor postre hechizo1 hechizo2 = hechizo1
    |otherwise = hechizo2

--Construir una lista infinita de postres, y construir un mago con infinitos hechizos.
infinitosPostres :: [Postre]
infinitosPostres = cycle [bizcochoBorracho, tarta]

infinitosPostres' :: [Postre]
infinitosPostres' = repeat bizcochoBorracho 

infinitosMagos :: [Mago]
infinitosMagos = repeat harry

{-
Suponiendo que hay una mesa con infinitos postres, y pregunto si algún hechizo los deja listos
¿Existe alguna consulta que pueda hacer para que me sepa dar una respuesta? Justificar conceptualmente.

Debido al lazy evaluation de Haskell, en caso de que haya un postre que no quede lista dara False, 
esto debido a que no necesita la lista infinitas de postres para poder ejecutar.
En caso de que efectivamente todos los postres queden listos, quedara ejecutando hasta un stack overflow.
-}

{-
Suponiendo que un mago tiene infinitos hechizos ¿Existe algún caso en el que se puede encontrar al mejor hechizo? 

No, no se podria. Esto debido a que la lista de hechizos es infinita, por ende nunca terminaria de verificar 
si hay alguno mejor que otro. 
-}