module Library where
import PdePreludat
import GHC.Num (Num)
import System.Mem (performGC)

doble :: Number -> Number
doble numero = numero + numero
 

type Material = String

data Personaje = Personaje {
    nombre:: String,
    puntaje:: Number,
    inventario:: [Material]
} deriving Show


--Craft
{-
Craftear consiste en construir objetos a partir de otros objetos. Para ello se cuenta con recetas que consisten en una 
lista de materiales que se requieren para craftear un nuevo objeto. En ninguna receta hace falta más de una unidad de 
mismo material. La receta también especifica el tiempo que tarda en construirse. Todo material puede ser componente de
una receta y todo objeto resultante de una receta también es un material y puede ser parte en la receta de otro.
-}
data Receta = Receta {
    producto :: Material,
    materiales :: [Material],
    tiempoCrafteo :: Number
} deriving Show

fogata :: Receta
fogata = Receta "Fogata" ["Madera" , "Fosforo"] 10

polloAsado :: Receta
polloAsado = Receta "PolloAsado" ["Fogata" , "Pollo"] 300

sueter :: Receta
sueter = Receta "Sueter" ["Lana" , "Agujas" , "Tintura"] 600

gonza :: Personaje
gonza = Personaje "Gongarfon" 100 ["Madera", "Fosforo", "Pollo", "Lana", "Agujas", "Tintura"]

santi :: Personaje
santi = Personaje "SantiElTonto" 1000 ["Sueter",  "Pollo", "Fogata", "Pollo"]

--1

type Crafteo = Receta -> Personaje -> Personaje
type Materiales = [Material]

--Hacer las funciones necesarias para que un jugador craftee un nuevo objeto
craftear :: Crafteo
craftear receta personaje
    |cuentaConMateriales receta personaje = agregarInventario receta (eliminarMaterial receta (aumentarPuntos receta personaje))
    |otherwise = cambiarPuntaje (-100) personaje

--El jugador debe quedar con el nuevo objeto en su inventario
agregarInventario :: Receta -> Personaje -> Personaje
agregarInventario receta personaje = personaje {inventario = inventario personaje ++ [producto receta]}

--El jugador debe quedar sin los materiales usados para craftear
eliminarMaterial :: Receta -> Personaje -> Personaje
eliminarMaterial receta personaje = personaje {inventario = foldl eliminarMaterialAux (inventario personaje) (materiales receta)}

eliminarMaterialAux :: Materiales -> Material -> Materiales
eliminarMaterialAux [] _ = []
eliminarMaterialAux (x:xs) material
    |x == material = xs
    |otherwise = x : eliminarMaterialAux xs material

--La cantidad de puntos del jugador se incrementa a razón de 10 puntos por segundo utilizado en el crafteo.
aumentarPuntos :: Receta -> Personaje -> Personaje
aumentarPuntos receta personaje = personaje {puntaje = puntaje personaje + 10 * tiempoCrafteo receta}

--El objeto se craftea sólo si se cuenta con todos los materiales requeridos antes de comenzar la tarea.
--En caso contrario, no se altera el inventario, pero se pierden 100 puntos.
cuentaConMateriales :: Receta -> Personaje -> Bool
cuentaConMateriales receta personaje = all (`elem` inventario personaje) (materiales receta)

cambiarPuntaje :: Number -> Personaje -> Personaje
cambiarPuntaje puntajeSumar personaje = personaje {puntaje = puntaje personaje + puntajeSumar}

--2
type Recetas = [Receta]

--Encontrar los objetos que podría craftear un jugador y que le permitirían como mínimo duplicar su puntaje.
puedeCraftear :: Recetas -> Personaje -> Recetas
puedeCraftear [] _ = [] 
puedeCraftear (x:xs) personaje
    |cuentaConMateriales x personaje && duplicaPuntaje x personaje = x : puedeCraftear xs personaje
    |otherwise = puedeCraftear xs personaje 

duplicaPuntaje :: Receta -> Personaje -> Bool
duplicaPuntaje receta personaje = puntaje (aumentarPuntos receta personaje) >= (puntaje personaje * 2)

--Hacer que un personaje craftee sucesivamente todos los objetos indicados en la lista de recetas. 
crafteoSucesivos :: Recetas -> Personaje -> Personaje
crafteoSucesivos recetas personaje = foldl (flip craftear) personaje recetas

--Averiguar si logra quedar con más puntos en caso de craftearlos a todos sucesivamente en el orden indicado o al revés.
convieneCraftearAlReves :: Recetas -> Personaje -> Bool
convieneCraftearAlReves recetas jugador = puntaje (crafteoSucesivos recetas jugador) < puntaje (crafteoSucesivos (reverse recetas) jugador)

--Mine
{-
El mundo del videojuego se compone de biomas, donde cada bioma tiene muchos materiales. Para poder minar en un bioma particular el personaje 
debe tener un elemento necesario según el bioma. Por ejemplo, en un bioma ártico, donde hay hielo, iglues y lobos, se debe tener un suéter. 

Cuando un personaje va a minar a un bioma, si cuenta con el elemento necesario, agrega a su inventario uno de los materiales del bioma y gana 50 puntos.
La forma de elegir cuál es el material del bioma a conseguir, depende de la herramienta que use al minar. Por ejemplo, el hacha hace que se mine 
el último de los materiales del bioma, mientras que la espada actúa sobre el primero de ellos. Existe tambien el pico, que por ser más preciso 
permite apuntar a una determinada posición de los materiales. Por ejemplo, si un personaje con un sueter en su inventario mina el artico con 
un pico de precisión 1, agrega un iglú a su inventario. En caso de no poder minar por no tener lo necesario el personaje se va con las manos
vacías y sigue como antes.

-}

type Herramienta = Bioma -> Material

data Bioma = Bioma {
    nombreBioma :: String,
    materialesBioma :: Materiales,
    condicionMinado :: Material
}deriving Show

tieneElemento :: Materiales -> Material -> Bool
tieneElemento materiales materialRequerido = materialRequerido `elem` materiales

hacha :: Herramienta
hacha bioma = last (materialesBioma bioma)

espada :: Herramienta
espada bioma = head (materialesBioma bioma)

pico :: Number -> Herramienta
pico posicion bioma = obtenerMaterial posicion (materialesBioma bioma)

obtenerMaterial :: Number -> Materiales -> Material
obtenerMaterial posicion materiales = materiales !! posicion

--Punto 1
minar :: Herramienta -> Personaje -> Bioma -> Personaje
minar herramienta personaje bioma
    |tieneElemento (inventario personaje) (condicionMinado bioma) = (cambiarPuntaje 50 . agregarMaterial (herramienta bioma)) personaje
    |otherwise = personaje

agregarMaterial :: Material -> Personaje -> Personaje
agregarMaterial materialAgregar personaje = personaje {inventario = materialAgregar : inventario personaje} 

--Punto 2
pala :: Herramienta
pala bioma = (obtenerMaterial (length (materialesBioma bioma) `div` 2) . materialesBioma) bioma

pala' :: Herramienta
pala' bioma = obtenerMaterial (length (materialesBioma bioma) `div` 2) (materialesBioma bioma)

azada :: String -> Herramienta
azada materialBuscado bioma = head (filter (\materialDelBioma -> materialBuscado == materialDelBioma) (materialesBioma bioma))
