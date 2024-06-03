import Text.Show.Functions
--PUNTO 1
data Heroe = Heroe {
    epiteto :: String,
    reconocimiento :: Int,
    artefactos :: [Artefacto],
    tareas :: [Tarea] --una tarea es una función que va de héroe a héroe, pero se le pone un alias para mejorar la expresividad 
} deriving (Show)

data Artefacto = Artefacto {
    nombre :: String,
    rareza :: Int
} deriving (Show) --esto también se podría resolver con una tupla

type Tarea = Heroe -> Heroe  --toda tarea es una funcion que va de heroe a heroe pero no toda funcion de heroe a heroe es una tarea, es mejor usar la semántica de tarea donde corresponda y sea mas expresivo. En el caso del punto 2 es mejor usar Heroe -> Heroe en vez de tarea ya que no tiene sentido que morirse sea una tarea

--PUNTO 2
pasarALaHistoria :: Heroe -> Heroe
{-
pasarALaHistoria unHeroe 
    | reconocimiento unHeroe > 1000 = unHeroe {epiteto = "El Mítico"} --o: = Heroe "El Mítico" (reconocimiento unHeroe (artefactos unHeroe) (tareas unHeroe) lo de las llaves es un chiche de haskell que se puede utilizar cuando definimos un data de la forma en la que lo hicimos con el Heroe
    | reconocimiento unHeroe >= 500 = unHeroe {epiteto = "El magnífico", artefactos = lanzaDeOlimpo : artefactos unHeroe} --no se aclara que ademas tiene que ser menor a mil ya que si fuera mayor que dicho numero entraria a la guarda de arriba, si la guarda de arriba estuviera debajo de esta, habría que aclararlo ya que sería la primer guarda a la que entra.
    --Mala práctica: también podría ser: artefactos = artefactos unHeroe ++ [lanzaDeOlimpo]
    | reconocimiento unHeroe > 100 = unHeroe {epiteto = "Hoplita", artefactos = xiphos : artefactos unHeroe} --otra vez, no hay que aclarar lo de menor a 500 por lo explicado en el anterior.
    | otherwise = unHeroe
-}

--versión sin repetir lógica (mejor):
pasarALaHistoria unHeroe
    | reconocimiento unHeroe > 1000 = cambiarEpiteto "El mítico" unHeroe
--    | reconocimiento unHeroe >= 500 = cambiarEpiteto "El mítico" (unHeroe {artefactos = lanzaDeOlimpo : artefactos unHeroe}) se sigue pudiendo mejorar...
    | reconocimiento unHeroe >= 500 = cambiarEpiteto "El mítico" (agregarArtefacto lanzaDeOlimpo unHeroe)
    | reconocimiento unHeroe > 100 = cambiarEpiteto "Hoplita" $ agregarArtefacto xiphos unHeroe -- con composición quedaría: = cambiarHepiteto "Hoplita" . agregarArtefacto xiphos $ unHeroe

--para que funcione hay que definir las funciones (lo mejor es definir las funciones después de terminar con lo que estaba haciendo, no definirlas mientras hacia la funcion anterior) nuevas que pusimos y los artefactos (aplica lo mismo de definir después para eso) a agregar:

cambiarEpiteto :: String -> Heroe -> Heroe --o: String -> Tarea pero en este caso no tiene sentido llamarlo tarea
cambiarEpiteto unEpiteto unHeroe = unHeroe {epiteto = unEpiteto}

agregarArtefacto :: Artefacto -> Heroe -> Heroe
--agregarArtefacto unArtefacto unHeroe = unHeroe {artefactos = unArtefacto : artefactos unHeroe}
agregarArtefacto unArtefacto = cambiarArtefactos (unArtefacto :)

lanzaDeOlimpo :: Artefacto
lanzaDeOlimpo = Artefacto "Lanza del Olimpo" 100

xiphos :: Artefacto
xiphos = Artefacto "Xiphos" 50

relampagoDeZeus :: Artefacto
relampagoDeZeus = Artefacto "El relámago de Zeus" 500

--PUNTO 3
encontrarUnArtefacto :: Artefacto -> Tarea --aca tiene mas sentido tarea que Heroe -> Heroe 
--encontrarUnArtefacto unArtefacto unHeroe = ganaReconocimiento (rareza unArtefacto) . agregarArtefacto unArtefacto $ unHeroe --SE PUEDE SACAR AL HEROE !!! :D
encontrarUnArtefacto unArtefacto = ganaReconocimiento (rareza unArtefacto) . agregarArtefacto unArtefacto

ganaReconocimiento :: Int -> Heroe -> Heroe
ganaReconocimiento cantidad unHeroe = unHeroe {reconocimiento = cantidad + reconocimiento unHeroe}

escalarElOlimpo :: Tarea
escalarElOlimpo unHeroe = agregarArtefacto relampagoDeZeus . desecharArtefactosComunes . triplicarRarezaArtefactos . ganaReconocimiento 500 $ unHeroe --el enunciado es un poco ambiguo, no se entiende si al relampago de zeus hay q triplicarle la rareza o no, decidimos agregarlo a lo último

triplicarRarezaArtefactos :: Tarea
--triplicarRarezaArtefactos unHeroe = unHeroe {artefactos = map triplicarRarezaArtefactos . artefactos $ unHeroe}
triplicarRarezaArtefactos = cambiarArtefactos (map triplicarRarezaArtefacto)

triplicarRarezaArtefacto :: Artefacto -> Artefacto
triplicarRarezaArtefacto unArtefacto = unArtefacto {rareza = (*3) . rareza $ unArtefacto}

desecharArtefactosComunes :: Tarea
--desecharArtefactosComunes = unHeroe {artefactos = filter (not . esComun) (artefactos unHeroe)}
desecharArtefactosComunes = cambiarArtefactos (filter (not . esComun))

esComun :: Artefacto -> Bool
esComun unArtefacto = rareza unArtefacto < 1000
esComun' :: Artefacto -> Bool
esComun' = (<1000) . rareza

cambiarArtefactos :: ([Artefacto] -> [Artefacto]) -> Heroe -> Heroe
cambiarArtefactos modificador unHeroe = unHeroe {artefactos = modificador (artefactos unHeroe)}

ayudarACruzarLaCalle :: Int -> Tarea
ayudarACruzarLaCalle cantidadDeCuadras = cambiarEpiteto ("Gros" ++ replicate cantidadDeCuadras 'o')

matarUnaBestia :: Bestia -> Tarea 
matarUnaBestia unaBestia unHeroe
    | (debilidad unaBestia) unHeroe = cambiarEpiteto ("El asesino de " ++ nombreBestia unaBestia) $ unHeroe
    | otherwise = (cambiarEpiteto "El cobarde") . (cambiarArtefactos (drop 1)) $ unHeroe --drop 1 es lo mismo que tail, pero no rompe para listas vacías

data Bestia = Bestia {
    nombreBestia :: String,
    debilidad :: Debilidad
} deriving (Show)

type Debilidad = Heroe -> Bool

--PUTNO 4
heracles :: Heroe
heracles = Heroe "Guardían del Olimpo" 700 [pistolaRara, relampagoDeZeus] [matarAlLeonDeNemea]

pistolaRara :: Artefacto
pistolaRara = Artefacto "Fierro de la antigua Grecia" 1000

--PUNTO 5
matarAlLeonDeNemea :: Tarea
matarAlLeonDeNemea = matarUnaBestia leonDeNemea

leonDeNemea :: Bestia
leonDeNemea = Bestia "León de Nemea" ((>20) . length . epiteto) --en vez de definir una funcion al pedo, creo la funcion ya dentro de la definicion de bestia

--PUNTO 6
hacerUnaTarea :: Tarea -> Heroe -> Heroe
hacerUnaTarea unaTarea = agregarTarea unaTarea . unaTarea 

agregarTarea :: Tarea -> Heroe -> Heroe
agregarTarea unaTarea unHeroe = unHeroe {tareas = unaTarea : tareas unHeroe}

--PUNTO 7
presumir :: Heroe -> Heroe -> (Heroe , Heroe)
presumir unHeroe otroHeroe
    | reconocimiento unHeroe > reconocimiento otroHeroe = (unHeroe , otroHeroe)
    | reconocimiento unHeroe < reconocimiento otroHeroe = (otroHeroe , unHeroe)
    | sumatoriaRarezas unHeroe > sumatoriaRarezas otroHeroe = (unHeroe , otroHeroe)
    | sumatoriaRarezas otroHeroe > sumatoriaRarezas otroHeroe = (otroHeroe , unHeroe)
    | otherwise = presumir (realizarLabor (tareas otroHeroe) unHeroe) (realizarLabor (tareas unHeroe) otroHeroe)
    --FALTA LA ABSTRACCION DEL GANADOR Y PERDEDOR !!!

presumir' heroe1 heroe2
    | gana heroe1 heroe2 = (heroe1 , heroe2)
    | gana heroe2 heroe1 = (heroe2 , heroe1)
    | otherwise = presumir' (realizarTareasDe heroe1 heroe2) (realizarTareasDe heroe1 heroe2)

realizarTareasDe :: Heroe -> Heroe -> Heroe
realizarTareasDe unHeroe otroHeroe = realizarLabor (tareas otroHeroe) unHeroe

gana :: Heroe -> Heroe -> Bool
gana ganador perdedor = reconocimiento ganador > reconocimiento perdedor || 
                        reconocimiento ganador == reconocimiento perdedor && sumatoriaRarezas ganador > sumatoriaRarezas perdedor
--no se usan guardas porque devuelve bool, entonces se puede resolver con un "calculo combinado de lógica"

--sumatoriaRarezas
sumatoriaRarezas = sum . map rareza . artefactos

--PUNTO 8
--nada, se queda pensando y no llega nunca a nada

--PUNTO 9
realizarLabor :: [Tarea] -> Heroe -> Heroe
realizarLabor unasTareas unHeroe = foldl (flip hacerUnaTarea) unHeroe unasTareas

--PUNTO 10
--no, no se podrá conocer el estado final porque se iterará infinitamente y nunca podrá mostrarse un "estado final"