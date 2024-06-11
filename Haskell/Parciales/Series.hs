module LibraryEli where
import PdePreludat
import Data.List (sort)
import Data.List (find)

-- ------------------------- Dominio ---------------------------
data Serie = UnaSerie {
    nombreSerie :: Nombre,
    actores :: [(Actor, Orden)],
    presupuestoAnual :: Presupuesto, 
    cantTemps :: Number,
    rating :: Rating,
    cancelada :: Bool
} deriving (Show, Eq)

data Actor = UnActor {
    nombreActor :: Nombre,
    sueldo :: Sueldo,
    restricciones :: [Restriccion]
} deriving (Show, Eq)

-- ------------------------- Definición de Tipos ---------------------------
type Nombre = String
type Presupuesto = Number
type Rating = Number
type Orden = Number
type Sueldo = Number
type Restriccion = String
type Bienestar = Number

type Productor = Serie -> Serie

-- ------------------------- Ejemplos ---------------------------

paulRudd :: Actor
paulRudd = UnActor "Paul Rudd" 41000000 ["No actuar en bata", "Comer ensalada de rucula todos los dias"]

johnnyDepp :: Actor
johnnyDepp = UnActor "Johnny Depp" 20000000 []

helenaBonham :: Actor
helenaBonham = UnActor "Helena Bonham" 15000000 []

timBurton :: Productor
timBurton = conFavoritismos [johnnyDepp, helenaBonham]

-- ------------------------- Funciones ---------------------------
-- --------------- Punto 1
-- Funcion A
estaEnRojo :: Serie -> Bool
estaEnRojo serie = presupuestoAnual serie < sumaSueldoTotal serie

sumaSueldoTotal :: Serie -> Number
sumaSueldoTotal = sum . map sueldo . conseguirActores 

conseguirActores :: Serie -> [Actor]
conseguirActores serie = map fst $ actores serie

-- Funcion B
esProblematica :: Serie -> Bool
esProblematica serie = menosDeXActores 3 (actoresConRestric serie)
    
actoresConRestric :: Serie -> [Actor]
actoresConRestric serie = filter (actorTieneRestric) (conseguirActores serie)

actorTieneRestric :: Actor -> Bool
actorTieneRestric = (>1) . length . restricciones

menosDeXActores :: Number -> [Actor] -> Bool
menosDeXActores delta = (>delta) . length  

-- --------------- Punto 2
-- Funcion A 
conFavoritismos :: [Actor] -> Productor
conFavoritismos (fav1:fav2:_) serie = serie{ 
    actores = (fav1, 1):(fav2, 2): drop 2 (ordenarActores (actores serie) 1)
}

ordenarActores :: [(Actor, Orden)] -> Number -> [(Actor, Orden)]
ordenarActores [] _ = []
ordenarActores actores num = find (ordenEs num) actores : ordenarActores actores (num + 1)

ordenEs :: Number -> (Actor, Orden) -> Bool
ordenEs num (_, orden) = orden == num

-- Funcion B (Arriba)

-- Funcion C
gatopardeitor :: Productor
gatopardeitor = id

-- Funcion D
estireitor :: Productor
estireitor serie = serie{
    cantTemps = cantTemps serie * 2 
}

-- Funcion E
desespereitor :: [Productor] -> Productor
desespereitor ideasProductor serie 
    | ((>=2) . length) ideasProductor = foldl aplicarProd serie ideasProductor
    | otherwise = serie

aplicarProd :: Serie -> Productor -> Serie
aplicarProd serie productor = productor serie

-- Funcion F

canceleitor :: Number -> Productor
canceleitor delta serie 
    | cancelableSerie delta serie = cancelarSerie serie
    | otherwise = serie

cancelarSerie :: Serie -> Serie
cancelarSerie serie = serie{cancelada = True}

cancelableSerie :: Number -> Serie  -> Bool
cancelableSerie delta serie = estaEnRojo serie || rating serie < delta

-- --------------- Punto 3
bienestarSerie :: Serie -> Bienestar
bienestarSerie serie 
    | cancelada serie = 0 
    | otherwise = mas4Temps serie + menos10Actores serie 

mas4Temps :: Serie -> Number
mas4Temps serie
    | cantTemps serie > 4 = 5
    | otherwise = (10 - cantTemps serie) * 2

menos10Actores :: Serie -> Number
menos10Actores serie 
    | menosDeXActores 10 (conseguirActores serie) = 3
    | otherwise = 10 - minResta serie

minResta :: Serie -> Number
minResta serie = max 2 (cantActoresRestric serie)

cantActoresRestric :: Serie -> Number
cantActoresRestric = length . filter actorTieneRestric . conseguirActores

-- --------------- Punto 4
seriesEfectivas :: [Serie] -> [Productor] -> [Serie]
seriesEfectivas series productores = map (aplicarProdEfectivo productores) series

aplicarProdEfectivo :: [Productor] -> Serie -> Serie
aplicarProdEfectivo productores serie = foldl (maxBienestarSerie serie) (head productores serie) (tail productores)

maxBienestarSerie :: Serie -> Serie -> Productor -> Serie
maxBienestarSerie serieOriginal serieProd prod
    | bienestarSerie serieProd > (bienestarSerie . prod) serieOriginal = serieProd
    | otherwise = prod serieOriginal

-- --------------- Punto 5

{-

a. ¿Se puede aplicar el productor gatopardeitor cuando tenemos una lista
infinita de actores?

Se podría aplicar, porque un resultado saldría por pantalla, pero ese resultado sería infinito.
No se quedaría tildado esperando evaluar algo, ya que la función id solo devuelve
lo que le entregaste, pero podría seguir hasta siempre imprimiendo los actores de la 
serie hasta generar stack overflow o que una persona lo pare. 

b. ¿Y a uno con favoritismos? ¿De qué depende?

SI NO TIENE ORDEN:
Un productor con favoritismo podría aplicar su función sin ningun problema ya que
se beneficiaría de la lazy evaluation de Haskell, que al evaluar primero las funciones
se daría cuenta que solo tiene que sacar los primeros 2 elementos de la lista, no evaluarla
por completo, evitando el problema que generaría si tuviera un motor de evaluación eager
donde primero se fijaría los parametros y luego la función. 

SI TIENE ORDEN: NO

-}

-- --------------- Punto 6

esControvertida :: Serie -> Bool
esControvertida serie = sort (listaSueldos serie) == listaSueldos serie
    
listaSueldos :: Serie -> [Number]
listaSueldos = map sueldo . conseguirActores

-- --------------- Punto 7

{-

7. Explicar la inferencia del tipo de la siguiente función:

funcionLoca x y = filter (even.x) . map (length.y) 

- En primer lugar, se puede notar que a la función le esta llegando un tercer parametro
llamemoslo z, que es una lista, a la cual se le aplica filter (even.x) . map (length.y)

- Luego, como a esta lista se le aplica length . y, podemos asumir que y es una función que va
desde el tipo que tiene la lista z a otra lista de cualquier tipo (no necesartiamente el original de z), 
ya que length recibe listas de cualquier tipo. Por lo tanto, 
la funcion y recibe un parametro de cualquier tipo y devuelve listas. 

- map (length.y) devuelve entonces una lista de Number. 

- Pasando a la segunda parte de la función, podemos inferir que x es otra función ya que
se compone con even, de la misma manera que la función y lo hizo previamente con length. 

- Como x se aplica a la lista de Number, entonces su primer parametro recibido es un Number
y como luego debe aplicarse even, debe devolver un Number también.

x
funcionLoca :: [a] -> (Number -> Number) -> (a -> [b]) -> [Number]
funcionLoca listaZ funcionX funcionY 

-}