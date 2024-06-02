module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

type Palabra = String
type Verso = String
type Estrofa = [Verso]
type Artista = String -- Solamente interesa el nombre


esVocal :: Char -> Bool
esVocal = flip elem "aeiou"

tieneTilde :: Char -> Bool
tieneTilde = flip elem "áéíóú"

cumplen :: (a -> b) -> (b -> b -> Bool) -> a -> a -> Bool
cumplen f comp v1 v2 = comp (f v1) (f v2)

{-
    -Determinar si dos palabras riman. Es decir, si generan una rima, ya sea asonante o consonante, 
    pero teniendo en cuenta que dos palabras iguales no se consideran una rima.
    -Enumerar todos los casos de test representativos (clases de equivalencia) de la función anterior. 
-}
palabrasRiman :: Palabra -> Palabra -> Bool
palabrasRiman palabra1 palabra2 = sonDiferentes palabra1 palabra2 && esRima palabra1 palabra2

sonDiferentes :: Palabra -> Palabra -> Bool
sonDiferentes palabra1 palabra2 = palabra1 /= palabra2

esRima :: Palabra -> Palabra -> Bool 
esRima palabra1 palabra2 = esAsonante palabra1 palabra2 || esConsonante palabra1 palabra2

esAsonante ::Palabra -> Palabra -> Bool
esAsonante = cumplen (ultimasVocales 2) (==)

esConsonante ::Palabra -> Palabra -> Bool
esConsonante = ultimasLetrasIguales

ultimasLetrasIguales :: Palabra -> Palabra -> Bool
ultimasLetrasIguales palabra1 palabra2 = obtenerNUltimasletras 3 palabra1 == obtenerNUltimasletras 3 palabra2

obtenerNUltimasletras :: Number -> Palabra -> String
obtenerNUltimasletras n = reverse . take n . reverse 

ultimasVocales :: Number -> Palabra -> String 
ultimasVocales n = obtenerNUltimasletras n . filter vocal 

vocal :: Char -> Bool
vocal letra = esVocal letra || tieneTilde letra

{-
    -Dos palabras riman por ser rima consonante
    -Dos palabras riman por ser rima asonante
    -Dos palabras no riman por ser iguales
    -Dos palabras no riman por no ser rima asonante o consonante
-}

{-
    Modelar las conjugaciones anteriores. Tener en cuenta que debe ser sencillo agregar más 
    conjugaciones al sistema, ya que se planea hacerlo en próximas iteraciones.
-}
type Conjugacion = Verso -> Verso -> Bool

conjugacionPorRimas :: Conjugacion 
conjugacionPorRimas = cumplen ultimaPalabra palabrasRiman 

-- conjugacionPorRimas :: Conjugacion 
-- conjugacionPorRimas verso1 verso2 = palabrasRiman (ultimaPalabra verso1) (ultimaPalabra verso2)

ultimaPalabra :: Verso -> String
ultimaPalabra = last . words

conjugacionAnadiplosis :: Conjugacion
conjugacionAnadiplosis verso1 verso2 = ultimaPalabra verso1 == primerPalabra verso2

primerPalabra :: Verso -> String
primerPalabra = head . words

    --Patrones:
    --Simple: es un patrón en el que riman 2 versos, especificados por su posición en la estrofa. 
type Patron = Estrofa -> Bool

patronSimple :: Number -> Number -> Patron
patronSimple n1 n2 estrofa = versosRiman (indiceEstrofa n1 estrofa) (indiceEstrofa n2 estrofa)

patronSimple' :: (Number , Number) -> Patron
patronSimple' (n1 , n2) estrofa = versosRiman (indiceEstrofa n1 estrofa) (indiceEstrofa n2 estrofa)

indiceEstrofa :: Number -> Estrofa -> Verso
indiceEstrofa n estrofa = (!!) estrofa (n-1)

versosRiman :: Verso -> Verso -> Bool
versosRiman v1 v2 = conjugacionPorRimas v1 v2 || conjugacionAnadiplosis v1 v2

    --Esdrújulas: Todos los versos terminan con palabras en esdrújula. Diremos que una palabra es 
    --esdrújula cuando la antepenúltima vocal está acentuada. Un ejemplo de este patrón sería:

--Solucion no recursiva.
patronEsdrujula :: Patron
patronEsdrujula = all (esEsdrujula . ultimaPalabra) 

esEsdrujula :: Palabra -> Bool
esEsdrujula = tieneTilde . head . ultimasVocales 3

--Solucion recursiva.
patronEsdrujula' :: Patron
patronEsdrujula' = versosTerminanEsdrujula 

versosTerminanEsdrujula :: Estrofa -> Bool
versosTerminanEsdrujula [x] = esEsdrujula (last (words x))
versosTerminanEsdrujula (x:xs) = esEsdrujula (last (words x)) && versosTerminanEsdrujula xs

    --Anáfora: Todos los versos comienzan con la misma palabra.
patronAnafora :: Patron
patronAnafora estrofa = sonIguales (primeraPalabraVerso estrofa)

primeraPalabraVerso :: Estrofa -> [String]
primeraPalabraVerso = map primerPalabra 

--Solucion Recursiva.
sonIguales :: [String] -> Bool
sonIguales [x] = True
sonIguales (x:y:ys) = (x == y) && sonIguales (y:ys)

--Otra posible resolucion.
sonIguales' :: [Palabra] -> Bool
sonIguales' []                 = False -- (?) --No se igual, habria que preguntar al que hizo la consigna
sonIguales' (palabra:palabras) = all (== palabra) palabras

{-
    Cadena: Es un patrón que se crea al conjugar cada verso con el siguiente, usando siempre la misma conjugación. 
    La conjugación usada es elegida por el artista mientras está rapeando.
-}
--patronCadena :: (Verso -> Verso -> Bool) -> Estrofa -> Bool
patronCadena :: Conjugacion -> Patron
patronCadena _ [] = False
patronCadena _ [_] = True
patronCadena conjugacion (x:y:ys) = conjugacion x y && patronCadena conjugacion (y:ys)

{-
    CombinaDos: Dos patrones cualesquiera se pueden combinar para crear un patrón más 
    complejo, y decimos que una estrofa lo cumple cuando cumple ambos patrones a la vez. 
-}
-- patronCombinarDos :: (Estrofa -> Bool) -> (Estrofa -> Bool) -> Bool
patronCombinarDos :: Patron -> Patron -> Patron
patronCombinarDos patron1 patron2 estrofa = patron1 estrofa && patron2 estrofa

--Modelo patrones combinados.
aabb :: Patron
aabb = patronSimple 1 4 `patronCombinarDos` patronSimple 2 3

aabb' :: Patron
aabb' = patronCombinarDos (patronSimple 1 4) (patronSimple 2 3)

abab :: Patron
abab = patronSimple 1 3 `patronCombinarDos` patronSimple 2 4

abba :: Patron
abba = patronSimple' (1, 4) `patronCombinarDos` patronSimple' (2, 3)

hardcore :: Patron
hardcore = patronCombinarDos (patronCadena conjugacionPorRimas) patronEsdrujula

hardcore' :: Patron
hardcore' = patronCadena conjugacionPorRimas `patronCombinarDos` patronEsdrujula

{-
    ¿Se podría saber si una estrofa con infinitos versos cumple con el patrón hardcore? 
    ¿Y el aabb? Justifique en cada caso específicamente por qué (no valen respuestas genéricas).
-}
--Debido a que Haskell cuenta con una lazy evaluation seria posible saber si una estrofa con infinitos versos cumple con el patron hardcore, 
--esto debido a que si la primera conjugacion (conjugacionPorRimas) no se cumple, ya corta la ejecucion del programa.

listaInfinita :: Estrofa
listaInfinita = cycle ["cancione" , "fúncion"] --No cumple porque de false conjugacionPorRimas --> Se puede evaluar 

listaInfinita' :: Estrofa
listaInfinita' = cycle ["cáncion" , "fúncion"] --Cumple ambas condiciones, queda evaluando hasta stack overflow --> No se puede evaluar

--En cuanto a aabb, independientemente del valor booleano que otorgue la funcion, es posible ejecutar 
--la funcion con una lista infinita, esto gracias al lazy evaluation de Haskell.

{-
    Por ahora pudimos identificar las siguientes variables significativas de una puesta en escena:
    si el público está exaltado o no, la potencia (un número), además de, claro está, la estrofa del
    freestyle (una sola, la puesta es por estrofa) y el artista.
    Además nos dimos cuenta que en cada puesta en escena cada artista utiliza un estilo distinto,
    dependiendo del mensaje que quiere transmitir, que altera la puesta en escena original. 
    Identificamos los siguientes casos:
    --Gritar: aumenta la potencia en un 50%
    --Responder un acote: conociendo su efectividad, aumenta la potencia en un 20%, y
      además el público queda exaltado si la respuesta fue efectiva, sino no lo queda.
    --Tirar técnicas: se refiere a cuando el artista deja en evidencia que puede lograr algún
      patrón en particular, aumenta la potencia en un 10%, además el público se exalta si la 
      estrofa cumple con dicho patrón, sino no.
-}

data PuestaEnEscena = PuestaEnEscena {
    artista          :: Artista,
    publicoExaltado  :: Bool,
    potenciaPublico  :: Number,
    estrofaFreestyle :: Estrofa
}deriving (Show,Eq)

type Estilo = PuestaEnEscena -> PuestaEnEscena

gritar :: Estilo
gritar = modificarPotencia 0.5 

responderAcote ::Bool -> Estilo
responderAcote efectiva = exaltarPublico efectiva . modificarPotencia 0.2 

tirarTecnicas :: Patron -> Estilo
tirarTecnicas patron = exaltarPublicoSiCumple patron . modificarPotencia 0.1

modificarPotencia :: Number -> PuestaEnEscena -> PuestaEnEscena
modificarPotencia valor puesta = puesta {potenciaPublico = potenciaPublico puesta * (1 + valor)}

exaltarPublico :: Bool -> PuestaEnEscena -> PuestaEnEscena
exaltarPublico bool puesta = puesta {publicoExaltado = bool}

exaltarPublicoSiCumple :: Patron -> PuestaEnEscena -> PuestaEnEscena
exaltarPublicoSiCumple patron puesta = exaltarPublico (cumplePatron patron puesta) puesta  

cumplePatron :: Patron -> PuestaEnEscena -> Bool 
cumplePatron patron puesta = patron (estrofaFreestyle puesta)

{-
    Hacer que un artista se tire un freestyle a partir de la estrofa que quiere decir y el estilo
    que le quiera dar a su puesta en escena. Para ello se parte siempre de una puesta base 
    que tiene potencia 1 y el público tranquilo, la que luego varía según el estilo utilizado.
    El resultado de que un artista se tire un freestyle es una puesta en escena.
-}
puestaBase :: Artista -> Estrofa -> PuestaEnEscena
puestaBase mc estrofa = PuestaEnEscena {artista = mc, potenciaPublico = 1, publicoExaltado = False, estrofaFreestyle = estrofa} 

tirarFreestyle :: Artista -> Estrofa -> Estilo -> PuestaEnEscena
tirarFreestyle artista estrofa estilo = estilo (puestaBase artista estrofa)

--Jurados

{-
    type Jurado = [Criterio]
    data Criterio = Criterio {
        condicion :: PuestaEnEscena -> Bool,
        puntaje :: Number
    }

    -- Función principal para calcular el puntaje total de una puesta en escena
    puntajeTotal :: PuestaEnEscena -> Jurado -> Number
    puntajeTotal puesta = puntajeFinal . obtenerPuntajes puesta

    puntajeFinal :: [Number] -> Number
    puntajeFinal = max 3 . sum

    obtenerPuntajes :: PuestaEnEscena -> Jurado -> [Number]
    obtenerPuntajes puesta jurado = map puntaje (criteriosAplicables puesta jurado)

    -- Función auxiliar para verificar si un criterio se aplica a una puesta en escena
    criteriosAplicables :: PuestaEnEscena -> Jurado -> [Criterio]
    criteriosAplicables puesta = filter (`condicion` puesta)
-}



--Otra solucion usando tuplas


-- Define un tipo 'Jurado' como una lista de 'Criterio'.
type Jurado = [Criterio]

-- Define un tipo 'Criterio' como una tupla que contiene una función que toma una 'PuestaEnEscena' y devuelve un 'Bool',
-- y un 'Number' que representa el puntaje asociado a ese criterio.
type Criterio = (PuestaEnEscena -> Bool, Number)

-- Calcula el puntaje de una 'PuestaEnEscena' según los criterios de un jurado.
puntaje :: PuestaEnEscena -> Jurado -> Number
puntaje puesta = puntajeFinal . valoraciones . criteriosCumple puesta

-- Suma una lista de números y asegura un mínimo de 3 puntos.
puntajeFinal :: [Number] -> Number
puntajeFinal = max 3 . sum

-- Extrae los puntajes de los criterios.
valoraciones :: [Criterio] -> [Number]
valoraciones = map snd

-- Filtra los criterios que se cumplen para una 'PuestaEnEscena'.
criteriosCumple :: PuestaEnEscena -> Jurado -> [Criterio]
criteriosCumple puesta = filter (($ puesta) . fst)

-- Define un tipo 'Performance' como una lista de 'PuestaEnEscena' del mismo artista.
type Performance = [PuestaEnEscena]

-- Define un tipo 'Batalla' como una lista de 'PuestaEnEscena' de diferentes artistas.
type Batalla = Performance

-- Determina qué artista gana la batalla según el puntaje otorgado por los jurados.
seLlevaElCinturon :: [Jurado] -> Batalla -> Artista
seLlevaElCinturon jurados =
  artistaPerformance . performanceGanadora jurados . separarPorArtistas

-- Obtiene el artista de la primera 'PuestaEnEscena' en una 'Performance'.
artistaPerformance :: Performance -> Artista
artistaPerformance = artista . head

-- Determina la performance ganadora comparando los puntajes totales de dos performances.
-- Si hay empate, lanza un error indicando "REPLICA".
performanceGanadora :: [Jurado] -> (Performance, Performance) -> Performance
performanceGanadora jurados (performance1, performance2)
  | puntajeTotal jurados performance1 > puntajeTotal jurados performance2 = performance1
  | puntajeTotal jurados performance1 < puntajeTotal jurados performance2 = performance2
  | otherwise = error "REPLICA"

-- Separa las puestas en escena de la batalla en dos performances distintas según el artista.
separarPorArtistas :: Batalla -> (Performance, Performance)
separarPorArtistas batalla =
  splitBy ((artistaPerformance batalla ==) . artista) batalla

-- Calcula el puntaje total de una performance sumando los puntajes de cada puesta en escena.
puntajeTotal :: [Jurado] -> Performance -> Number 
puntajeTotal jurados = sum . map (`puntajeTotalDePuesta` jurados)

-- Calcula el puntaje total de una 'PuestaEnEscena' sumando los puntajes dados por cada jurado.
puntajeTotalDePuesta :: PuestaEnEscena -> [Jurado] -> Number
puntajeTotalDePuesta puesta = sum . map (puntaje puesta)

-- Toma una condición y una lista, y devuelve un par de listas: una con los elementos que cumplen la condición y otra con los que no la cumplen.
splitBy :: (a -> Bool) -> [a] -> ([a], [a])
splitBy cond lista = (filter cond lista, filter (not . cond) lista)
