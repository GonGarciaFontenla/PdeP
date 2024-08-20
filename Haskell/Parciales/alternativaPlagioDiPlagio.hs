--enunciado: https://docs.google.com/document/d/1ilESbsH_umXHRznhN0SOOhzjaR7f52qYOy677lczu7s/edit

import Text.Show.Functions () 
import Data.List(genericLength, intersect)


{-
ATENCION: ESTA SOLUCION ES MUY MALA, REPITE MUCHA LOGICA Y CARECE DE ABSTRACCIONES
pero ya estoy muy quemado como para seguir, en otro momento la actualizaré con mejoras
espero que mientras tanto le pueda servir a alguien :)
-}

data Autor = Autor {
    obras :: [Obra],
    nombre :: String
}

data Obra = Obra {
    texto :: Texto,
    anioPublicacion :: Int
}

type Texto = String

--Autores y obras

habiaUnaVezUnPatoPlagio :: Obra
habiaUnaVezUnPatoPlagio = Obra {
    texto = "Había una vez un pato.",
    anioPublicacion = 1997
}

habiaUnaVezUnPatoOriginal :: Obra
habiaUnaVezUnPatoOriginal = Obra {
    texto = "¡Había una vez un pato!",
    anioPublicacion = 1996
}

viejas :: Obra
viejas = Obra {
    texto = "Mirtha, Susana y Moria.",
    anioPublicacion = 2010
}

nombreComplicado :: Obra
nombreComplicado = Obra {
    texto = "La semántica funcional del amoblamiento vertebral es riboficiente",
    anioPublicacion = 2020
}

complicadasViejas :: Obra
complicadasViejas = Obra {
    texto = "La semántica funcional de Mirtha, Susana y Moria.",
    anioPublicacion = 2022
}

tomas :: Autor
tomas = Autor {
    obras = [viejas, habiaUnaVezUnPatoPlagio],
    nombre = "Tomás"
}

santiago :: Autor
santiago = Autor {
    obras = [habiaUnaVezUnPatoOriginal, nombreComplicado],
    nombre = "Santiago"
}

noSePensar :: Autor
noSePensar = Autor {
    obras = [complicadasViejas],
    nombre = "Vergüenza"
}

versionCruda :: Texto -> Texto
versionCruda = reemplazarVocales . filter (not . caracterInutil)

esVocal :: Char -> Bool
esVocal = flip elem "aeiouáéíóú"

caracterInutil :: Char -> Bool
caracterInutil = flip elem "?¿.,¡!:;-_/()"

reemplazarVocales :: Texto -> Texto
reemplazarVocales = map reemplazarVocal

reemplazarVocal :: Char -> Char
reemplazarVocal 'á' = 'a'
reemplazarVocal 'é' = 'e'
reemplazarVocal 'í' = 'i'
reemplazarVocal 'ó' = 'o'
reemplazarVocal 'ú' = 'u'
reemplazarVocal caracter = caracter

--Plagios
type Plagio = Obra -> Obra -> Bool

sePublicoDespues :: Obra -> Obra -> Bool
sePublicoDespues original posiblePlagio = anioPublicacion posiblePlagio > anioPublicacion original

copiaLiteral :: Plagio
copiaLiteral original posiblePlagio = ((versionCruda . texto) original == (versionCruda . texto) posiblePlagio) && sePublicoDespues original posiblePlagio

empiezaIgual :: Int -> Plagio
empiezaIgual cantidad original posiblePlagio = primerosNCaracteresIguales cantidad original posiblePlagio && esMasCorta original posiblePlagio  && sePublicoDespues original posiblePlagio

esMasCorta :: Obra -> Obra -> Bool
esMasCorta masLarga masCorta = (length . texto) masLarga > (length . texto) masCorta

primerosNCaracteresIguales :: Int -> Obra -> Obra -> Bool
primerosNCaracteresIguales n obra1 obra2 = (take n . texto) obra1 == (take n . texto) obra2

leAgregaronIntro :: Plagio
leAgregaronIntro original posiblePlagio = nombreIncluidoAlFinal original posiblePlagio && sePublicoDespues original posiblePlagio

nombreIncluidoAlFinal :: Obra -> Obra -> Bool
nombreIncluidoAlFinal incluida contenedora = ((reverse . versionCruda . texto) incluida) == (take ((length . versionCruda . texto) incluida) ((reverse . versionCruda . texto) contenedora))

textoIncluidoOCamuflado :: Plagio
textoIncluidoOCamuflado = \original posiblePlagio -> intersect ((versionCruda . texto) posiblePlagio) ((versionCruda . texto) posiblePlagio) == (versionCruda . texto) original && sePublicoDespues original posiblePlagio

--Bots

type Bot = [Plagio]

copySeeker :: Bot
copySeeker = [copiaLiteral, textoIncluidoOCamuflado]

extremeAnalyzer :: Bot --porque analiza los extremos jaja malisimo xd
extremeAnalyzer = [empiezaIgual 8, leAgregaronIntro]

noPlagiosAllowed :: Bot --tiene todos los tipos de plagio posibles
noPlagiosAllowed = [leAgregaronIntro, copiaLiteral, textoIncluidoOCamuflado, empiezaIgual 8]

detectarPlagio :: Bot -> Plagio
detectarPlagio [] _ _ = False
detectarPlagio (detector1 : detectores) original posiblePlagio = detector1 original posiblePlagio || detectarPlagio detectores original posiblePlagio

cadenaDePlagiadores ::  Bot -> [Autor] -> Bool
cadenaDePlagiadores _ [] = True
cadenaDePlagiadores _ [unicoAutor] = True
cadenaDePlagiadores bot [plagiador, original] = plagioAutores bot original plagiador
cadenaDePlagiadores bot (plagiador : original : autores) = plagioAutores bot original plagiador && cadenaDePlagiadores bot (original : autores)

plagioAutores :: Bot -> Autor -> Autor -> Bool
plagioAutores bot original plagiador = detectarPlagioListas bot (obras original) (obras plagiador)

detectarPlagioListas :: Bot -> [Obra] -> [Obra] -> Bool
detectarPlagioListas _ [] _ = False
detectarPlagioListas _ _ [] = False
detectarPlagioListas bot (original1 : originales) (plagio1 : plagios) = detectarPlagio bot original1 plagio1 || detectarPlagioListas bot originales (plagio1 : plagios) || detectarPlagioListas bot (original1 : originales) plagios

aprendieron :: Bot -> [Autor] -> Bool
aprendieron _ [unicoAutor] = True
aprendieron bot (autor1 : autor2 : autores) = cadenaDePlagiadores bot (autor1 : autor2 : autores) && (plagioAutoresMasDeUnaVez bot autor2 autor1 && aprendieron bot (autor2 : autores))

plagioAutoresMasDeUnaVez :: Bot -> Autor -> Autor -> Bool
plagioAutoresMasDeUnaVez bot original plagiador = detectarPlagioListasRegistrandoResultados bot (obras original) (obras plagiador)

detectarPlagioListasRegistrandoResultados :: Bot -> [Obra] -> [Obra] -> Bool
detectarPlagioListasRegistrandoResultados _ [] _ = True
detectarPlagioListasRegistrandoResultados _ _ [] = True
detectarPlagioListasRegistrandoResultados bot (original1 : originales) (plagio1 : plagios) = not(hayUnSoloTrue ((detectarPlagio bot original1 plagio1) : (detectarPlagioListasRegistrandoResultados bot originales (plagio1 : plagios)) : (detectarPlagioListasRegistrandoResultados bot (original1 : originales) plagios) : []))

hayUnSoloTrue :: [Bool] -> Bool
hayUnSoloTrue listaBooleanos 
    | length (filter (==True) listaBooleanos) <= 1 = True --si alguno nunca hizo palgio, se considera que ya aprendió
    | otherwise = False

--Infinito
ciempiesInterminabe :: Obra
ciempiesInterminabe = Obra {
    texto = concat ("habia una vez un ciempes que " : cycle ["se cayó ", "y se levantó y "]),
    anioPublicacion = 1800
}

-- Lo que sucede si se desea verificar si esa obra es plagio de otra con cada una de las formas existentes depende de los criterios del bot que se use para tal fin. Si se intenta averiguar si es una copia literal, si le agregaron una introducción o si es que su texto se encuentra incluido dentro del de otra, será imposible ya que todos estos casos implican el conocimiento total del texto, lo que es imposible de obtener. Pero, si lo que se desea es saber si empieza igual que otra, podría obtenerse tranquilamente una respuesta definida, ya que esto solo implica saber cuáles son sus primeras n letras y compararlas contra la otra obra, lo que es perfectamente posible gracias a la Lazy Evaluation de Haskell que lo que hace es evaluar siempre primero lo que tiene qué hacer y luego qué parámetros utilizar, asi que si solo necesita, por ejemplo, las primeras 10 letras de la obra infinita, sólo "calculará" la obra hasta obtener eso, no se quedará calculando lo que queda de lista porque no lo necesita.
