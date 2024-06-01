module Library where
import PdePreludat
import GHC.Num (Num)
import System.Mem (performGC)
import GHC.Base (List)
import Data.Char (isUpper)
import GHC.Generics (Generic(Rep))

doble :: Number -> Number
doble numero = numero + numero

{-
De los plomeros conocemos su nombre, la caja de herramientas que llevan, 
el historial de reparaciones que han hecho y el dinero que llevan encima.

Hay unas cuantas herramientas que un plomero puede tener encima, y de cada 
una conocemos su denominación (nombre de la herramienta), su precio y el material 
de su empuñadura, que puede ser hierro, madera, goma o plástico.
-}

data Plomero = Plomero {
    nombre :: String, 
    caja :: [Herramienta], 
    historial :: [Reparacion], 
    dinero :: Number
}deriving Show

data Herramienta = Herramienta { 
    denominacion :: String, 
    precio :: Number, 
    empuniadura :: Mango
}deriving Show

data Mango = Hierro | Goma | Madera | Plastico deriving (Show, Eq)

{-
Mario, un plomero que tiene $1200, no hizo ninguna reparación hasta ahora y en su caja
de herramientas lleva una llave inglesa con mango de hierro que tiene un precio de $200 
y un martillo con empuñadura de madera que le salió $20.
Wario, tiene 50 centavos encima, no hizo reparaciones, lleva infinitas llaves francesas,
 obviamente de hierro, la primera le salió un peso, pero cada una que compraba le salía 
 un peso más cara. La inflación lo está matando. 
-}

mario :: Plomero
mario = Plomero "Mario" [llaveInglesa, martillo] [] 1200

wario :: Plomero
wario = Plomero "Wario" (herramientaInfinita llaveFrancesa) [] 0.50

llaveInglesa :: Herramienta
llaveInglesa = Herramienta "llave inglesa" 10001 Madera

martillo :: Herramienta
martillo = Herramienta "martillo" 20 Madera

llaveFrancesa :: Herramienta
llaveFrancesa = Herramienta "llave francesa" 1 Hierro

destonillador :: Herramienta
destonillador = Herramienta "Destonillador" 0 Plastico


herramientaInfinita :: Herramienta -> [Herramienta]
herramientaInfinita herramienta = [aumentarPrecio herramienta precio | precio <- [0..]]

aumentarPrecio :: Herramienta -> Number-> Herramienta 
aumentarPrecio herramienta valor = herramienta {precio = precio herramienta + valor}

--Saber si un plomero:
--Tiene una herramienta con cierta denominación.

tieneHerramienta :: String -> Plomero -> Bool
tieneHerramienta herramienta plomero = herramienta `elem` denominacionHerramienta (caja plomero)

denominacionHerramienta :: [Herramienta] -> [String]
denominacionHerramienta = map nombreHerramienta

nombreHerramienta :: Herramienta -> String
nombreHerramienta = denominacion 

--Es malvado: se cumple si su nombre empieza con Wa.}
esMalvado :: Plomero -> Bool
esMalvado plomero = "Wa" == take 2 (nombre plomero)

--Puede comprar una herramienta: esto sucede si tiene el dinero suficiente para pagar el precio de la misma.
puedeComprar :: Herramienta -> Plomero -> Bool
puedeComprar = tieneDinero

tieneDinero :: Herramienta -> Plomero -> Bool
tieneDinero herramienta plomero = dinero plomero >= precio herramienta 

--Saber si una herramienta es buena, cumpliendose solamente si tiene empuñadura de 
--hierro que sale más de $10000 o es un martillo con mango de madera o goma.
esBuena :: Herramienta -> Bool
esBuena herramienta = 
    (esDeMaterial herramienta Hierro && precioMayor herramienta 10000) ||
    (esMartillo herramienta && (esDeMaterial herramienta Madera || esDeMaterial herramienta Goma))

esDeMaterial :: Herramienta -> Mango -> Bool
esDeMaterial herramienta mango = empuniadura herramienta == mango

precioMayor :: Herramienta -> Number -> Bool
precioMayor herramienta valor = precio herramienta > valor

esMartillo :: Herramienta -> Bool
esMartillo herramienta = denominacion herramienta == "martillo"

--Todo plomero necesita comprar una herramienta, cuando lo hace paga su precio 
--y agrega la herramienta a las suyas. Solo sucede si puede pagarlo.
comprarHerramienta :: Herramienta -> Plomero -> Plomero
comprarHerramienta herramienta plomero
    |puedeComprar herramienta plomero = agregarHerramienta herramienta (modificarDinero herramienta plomero)
    |otherwise = plomero

agregarHerramienta :: Herramienta -> Plomero -> Plomero
agregarHerramienta herramienta plomero = plomero {caja = herramienta : caja plomero}

modificarDinero :: Herramienta -> Plomero -> Plomero
modificarDinero herramienta plomero = plomero {dinero = dinero plomero - precio herramienta}

{-
Hay un sinfín de reparaciones que los plomeros deben resolver. Cada una de ellas goza de una descripción
del problema a reparar y un requerimiento que varía dependiendo de la reparación. Por ejemplo, una filtración
de agua requiere que un plomero tenga una llave inglesa en su caja de herramientas.
-}

--a)Modelar las reparaciones y la filtración de agua.
data Reparacion = Reparacion {
    descripcion :: String, 
    requerimiento :: Plomero -> Bool
}deriving Show

filtracionAgua :: Reparacion
filtracionAgua = Reparacion "Filtra agua" (tieneHerramienta "llave inglesa")

--Saber si una reparación es difícil: esto ocurre cuando su descripción es complicada, es decir que tiene 
--más de 100 caracteres y además es un grito, es decir está escrito totalmente en mayúsculas.

reparacionDificil :: Reparacion -> Bool
reparacionDificil reparacion = masCienCaracteres (descripcion reparacion) && todoMayuscula (descripcion reparacion)

masCienCaracteres :: String -> Bool
masCienCaracteres descripcion = (>100) (length descripcion)

todoMayuscula :: String -> Bool
todoMayuscula = all isUpper 

--Saber el presupuesto de una reparación, el cual se calcula como el 300% de la longitud de su descripción 
--(por eso es importante describir los problemas de manera sencilla).

presupuestoReparacion :: Reparacion -> Number
presupuestoReparacion reparacion = aumentarPorPorcentraje (descripcion reparacion)

aumentarPorPorcentraje :: String -> Number
aumentarPorPorcentraje descripcion = (* (300/100)) (length descripcion) 

{-
Hacer que un plomero haga una reparación. Si no puede resolverla te cobra $100 la visita. Si puede hacerla, 
cobra el dinero por el presupuesto de la misma y agrega esa reparación a su historial de reparaciones, además de:
--Si el plomero es malvado, le roba al cliente un destornillador con mango de plástico, claramente su precio es nulo.
--Si no es malvado y la reparación es difícil, pierde todas sus herramientas buenas.
--Si no es malvado ni es difícil la reparación, sólo se olvida la primera de sus herramientas.
-}
puedeHacerReparacion :: Reparacion -> Plomero -> Bool
puedeHacerReparacion reparacion plomero = requerimiento reparacion plomero || esMalvadoConMartillo plomero

esMalvadoConMartillo :: Plomero -> Bool
esMalvadoConMartillo plomero 
    |esMalvado plomero = tieneHerramienta "martillo" plomero
    |otherwise = False

cobrarDinero :: Reparacion -> Plomero -> Plomero
cobrarDinero reparacion plomero = plomero {dinero = dinero plomero + presupuestoReparacion reparacion}

agregarReparacion :: Reparacion -> Plomero -> Plomero
agregarReparacion reparacion plomero = plomero {historial = reparacion : historial plomero}

robarHerramienta :: Plomero -> Herramienta -> Plomero
robarHerramienta plomero herramienta = plomero {caja = herramienta : caja plomero}

pierdeHerramientasBuenas :: Plomero -> Plomero
pierdeHerramientasBuenas plomero = plomero {caja = soloMalas (caja plomero)}

soloMalas :: [Herramienta] -> [Herramienta]
soloMalas = filter (not . esBuena) 

sacarPrimerElemento :: [Herramienta] -> [Herramienta]
sacarPrimerElemento = tail 

efectosReparacion :: Reparacion -> Plomero -> Plomero
efectosReparacion reparacion plomero
    |esMalvado plomero = robarHerramienta plomero destornillador
    |reparacionDificil reparacion = pierdeHerramientasBuenas plomero 
    |otherwise = plomero {caja = sacarPrimerElemento (caja plomero)}

hacerReparacion :: Reparacion -> Plomero