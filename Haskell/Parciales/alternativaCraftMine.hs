--enunciado: https://docs.google.com/document/d/1i9rB5AzRswz_0Z4T1v5IgRhC3UT-d_Ib1K7LUeq5sa0/edit#heading=h.zanco9r7coid

import Text.Show.Functions ()
import Data.List(genericLength)

data Personaje = Personaje {
    nombre :: String,
    puntaje :: Int,
    inventario :: [Material]
} deriving (Show, Eq)

berty :: Personaje
berty = Personaje {
    nombre = "Berty",
    puntaje = 0,
    inventario = [Madera, Fosforo, Pollo, Pollo, Sueter]
}

data Material = Fogata | Madera | Fosforo | PolloAsado | Pollo | Sueter | Lana | Agujas | Tintura | Hielo | Iglu | Lobo | Tierra deriving (Show, Eq)

--Craft

data Receta = Receta{
    materialesNecesarios :: [Material],
    resultado :: Material,
    tiempo :: Int
} deriving (Show, Eq)

fogata :: Receta
fogata = Receta{
    materialesNecesarios = [Madera, Fosforo],
    resultado = Fogata,
    tiempo = 10
}

polloAsado :: Receta
polloAsado = Receta{
    materialesNecesarios = [Fogata, Pollo],
    resultado = PolloAsado,
    tiempo = 300
}

sueter :: Receta
sueter = Receta{
    materialesNecesarios = [Fogata, Pollo],
    resultado = Sueter,
    tiempo = 600
}

--Punto 1
agregarObjeto :: Material -> Personaje -> Personaje
agregarObjeto nuevoObjeto personaje = personaje {inventario = nuevoObjeto : inventario personaje}

quitarObjeto :: Material -> Personaje -> Personaje
quitarObjeto material personaje = personaje {inventario = foldl eliminarSolo1 (inventario personaje) [material]}

eliminarSolo1 :: [Material] -> Material -> [Material]
eliminarSolo1 [] _ = []
eliminarSolo1 (materialPersonaje : restoMaterialesPersonaje) materialNecesario
    | materialPersonaje == materialNecesario = restoMaterialesPersonaje
    | otherwise = materialPersonaje : eliminarSolo1 restoMaterialesPersonaje materialNecesario 

quitarMaterialesNecesarios :: [Material] -> Personaje -> Personaje
quitarMaterialesNecesarios [] personaje = personaje
quitarMaterialesNecesarios (material1 : unosMateriales) personaje = quitarObjeto material1 (quitarMaterialesNecesarios unosMateriales personaje)

tieneLosMateriales :: Personaje -> [Material] -> Bool
tieneLosMateriales personaje [] = True
tieneLosMateriales personaje (material1 : materiales) = elem material1 (inventario personaje) && tieneLosMateriales personaje materiales

modificarPuntaje :: (Int -> Int) -> Personaje -> Personaje
modificarPuntaje f personaje = personaje {puntaje = f . puntaje $ personaje}

craftear :: Receta -> Personaje -> Personaje
craftear receta personaje
    | tieneLosMateriales personaje (materialesNecesarios receta)  = agregarObjeto (resultado receta) . quitarMaterialesNecesarios (materialesNecesarios receta) . modificarPuntaje (+(10 * tiempo receta)) $ personaje
    | otherwise = modificarPuntaje (flip (-) 100) personaje

--Punto 2
sePuedeHacer :: Personaje -> Receta -> Bool
sePuedeHacer personaje receta = tieneLosMateriales personaje (materialesNecesarios receta)

duplicaPuntaje :: Personaje -> Receta -> Bool
duplicaPuntaje personaje receta = (puntaje . craftear receta $ personaje) >= puntaje personaje

recetasIdeales :: Personaje -> [Receta] -> [Receta]
recetasIdeales personaje recetas = filter (duplicaPuntaje personaje) (filter (sePuedeHacer personaje) recetas)

crafteoSucesivo :: Personaje -> [Receta] -> Personaje
crafteoSucesivo personaje recetas = foldl (flip craftear) personaje recetas

esMejorCraftearAlReves :: Personaje -> [Receta] -> Bool
esMejorCraftearAlReves personaje recetas = puntaje (crafteoSucesivo personaje recetas) < puntaje (crafteoSucesivo personaje (reverse recetas))

--Mine
data Bioma = Bioma{
    nombreBioma :: String,
    elementoNecesario :: Material,
    materiales :: [Material]
}

artico :: Bioma
artico = Bioma {
    nombreBioma = "Ártico",
    elementoNecesario = Sueter,
    materiales = [Hielo, Iglu, Lobo]
}

--Punto 1
minar :: Herramienta -> Personaje -> Bioma -> Personaje
minar herramienta personaje bioma
    | tieneLosMateriales personaje [elementoNecesario bioma] = modificarPuntaje (+50) . agregarObjeto (herramienta (materiales bioma)) $ personaje
    | otherwise = personaje

--Punto 2
type Herramienta = [Material] -> Material

hacha :: Herramienta
hacha = last

espada :: Herramienta
espada = head

pico :: Int -> Herramienta
pico precision = flip (!!) precision

pala :: Herramienta
pala materiales = pico ((`div` 2) . length $ materiales) materiales

azada :: Herramienta --No sirve para nada! siempre devuelve lo mismo (la tierra que pueda sacar sobre lo que se use (todo tiene tierra o polvillo))
azada = \materiales -> Tierra

tridente :: Material -> Herramienta --Este es mágico, te da lo que quieras! (siempre y cuando lo estes buscando en el lugar correcto)
tridente = \materialQueQueres materialesDelBioma -> head (filter (materialQueQueres==) materialesDelBioma)

--Los ejemplos se los dejo a quién vea la resolución, cualqueira puede ejecutar este codigo en la consola y empezar a jugar!