--enunciado: https://docs.google.com/document/d/1AtD9mZGiUNEKmZ_aaWSCoNaeowLTMUhFRVHm-GZIF-w/edit
import Text.Show.Functions () 
import Data.List(genericLength)

type Palabra = String
type Verso = String
type Estrofa = [Verso]
type Artista = String -- Solamente interesa el nombre

esVocal :: Char -> Bool
esVocal = flip elem "aeiouáéíóú"

tieneTilde :: Char -> Bool
tieneTilde = flip elem "áéíóú"

cumplen :: (a -> b) -> (b -> b -> Bool) -> a -> a -> Bool
cumplen f comp v1 v2 = comp (f v1) (f v2)

--estoy resolviendo esto en 2024, asi que las partes de clases de equivalencia no van a estar hechas, ya no se da el tema

--Rimas
type Rima = Palabra -> Palabra -> Bool
riman :: Rima
{-
riman palabra1 palabra2
    | palabra1 == palabra2 = False
    | rimaAsonante palabra1 palabra2 = True
    | rimaConsonante palabra1 palabra2 = True
    | otherwise = False
-}
--no se usan guardas para devolver Bool! ojo, es mejor usar lógica
riman palabra1 palabra2 = (palabra1 /= palabra2) && (rimaAsonante palabra1 palabra2 || rimaConsonante palabra1 palabra2)

rimaAsonante :: Rima
rimaAsonante palabra1 palabra2 = (take 2 . reverse . filter esVocal $ palabra1) == (take 2 . reverse . filter esVocal $ palabra2)

rimaConsonante :: Rima
rimaConsonante palabra1 palabra2 = (take 3 . reverse $ palabra1) == (take 3 . reverse $ palabra2)

--Conjugaciones
type Conjugacion = Verso -> Verso -> Bool

conjugan :: Conjugacion
{-
conjugan verso1 verso2
    | cumplen ultimaPalabra riman verso1 verso2 = True --conjugan por medio de rimas
    | ultimaPalabra verso2 == primerPalabra verso1 = True --conjugan haciendo anadiplosis
    | otherwise = False
-}
--no se usan guardas para devolver Bool! ojo, es mejor usar lógica
conjugan verso1 verso2 = conjuganPorMedioDeRimas verso1 verso2 || conjuganHaciendoAnadiplosis verso1 verso2

conjuganPorMedioDeRimas :: Conjugacion
conjuganPorMedioDeRimas verso1 verso2 = cumplen ultimaPalabra riman verso1 verso2

conjuganHaciendoAnadiplosis :: Conjugacion
conjuganHaciendoAnadiplosis verso1 verso2 = ultimaPalabra verso2 == primerPalabra verso1

ultimaPalabra :: Verso -> String
ultimaPalabra  = head . words . reverse

primerPalabra :: Verso -> String
primerPalabra = head . words

--Patrones
type Patron = Estrofa -> Bool

patronSimple :: Int -> Int -> Patron
patronSimple indiceVerso1 indiceVerso2 estrofa = cumplen ultimaPalabra riman (estrofa !! indiceVerso1) (estrofa !! indiceVerso1)

patronEsdrujula :: Patron
patronEsdrujula = all (esEsdrujula . last . words)

esEsdrujula :: Palabra -> Bool
esEsdrujula  = tieneTilde . (!!2) . reverse . (filter esVocal)

patronAnafora :: Patron
patronAnafora estrofa = all ((head (map (head . words) estrofa) ==) . head . words) estrofa

patronCadena :: Conjugacion -> Patron
patronCadena _ [] = True
patronCadena conjugacion (verso1 : verso2 : estrofa) = conjugacion verso1 verso2 && patronCadena conjugacion (verso2 : estrofa)

patronCombina2 :: Patron -> Patron -> Patron
patronCombina2 patron1 patron2 estrofa = (patron1 estrofa &&) . patron2 $ estrofa --patron1 estrofa && patron2 estrofa

patronAABB :: Patron
patronAABB = patronCombina2 (patronSimple 1 2) (patronSimple 3 4)

patronABAB :: Patron
patronABAB = patronCombina2 (patronSimple 1 3) (patronSimple 2 4)

patronABBA :: Patron
patronABBA = patronCombina2 (patronSimple 1 4) (patronSimple 2 3)

patronHardcore :: Patron
patronHardcore = patronCombina2 (patronCadena conjuganPorMedioDeRimas) patronEsdrujula

-- ¿Se podría saber si una estrofa con infinitos versos cumple con el patrón hardcore? ¿Y el aabb? Justifique en cada caso específicamente por qué (no valen respuestas genéricas).
-- Para una estofa con infinitos versos no podría saberse si cumple con el patrón hardcore, ya que este implica comparar siempre con el siguiente verso, lo que hace que si en ningún momento se rompe el patrón, seguirá evaluando y comparando siempre con el siguiente sin llegar a terminar nunca. En el caso mencionado de que se rompa el patrón en algún momento, si podría saberse el resultado final, que independientemente del largo de la lista, al encontrar que se rompe el patrón la función devolvería False gracias a la Lazy Evaluation de Haskell que lo permite, ya que sabe que no es necesario evaluar el resto de la lista si conoce que uno de sus miembros no cumple una condición que debe ser para todos, porque primero evalúa qué debe hacer y no los parámetros. Para el caso del patron aabb, podría saberse si se cumple independientemente del largo de la estrofa, ya que solo le interesan sus primeros 4 elementos, haciendo que sea capaz de decir si el patrón se cumple o no aunque la estrofa sea infinita, por la ya explicado sobre la lazy evaluation.

--Puesta en escena
data PuestaEnEscena = PuestaEnEscena {
    publicoExaltado :: Bool,
    potencia :: Float,
    estrofa :: Estrofa,
    estilo :: Estilo
} deriving (Show)

type Estilo = PuestaEnEscena -> PuestaEnEscena

gritar :: Estilo
gritar = aumentarPotencia 50

responderUnAcote :: Bool -> Estilo
responderUnAcote efectividad puestaEnEscena
    | efectividad = aumentarPotencia 20 . exaltarPublico $ puestaEnEscena
    | otherwise = puestaEnEscena

tirarTecnicas :: Patron -> Estilo
tirarTecnicas patron puestaEnEscena
    | patron . estrofa $ puestaEnEscena = aumentarPotencia 20 . exaltarPublico $ puestaEnEscena
    | otherwise = puestaEnEscena --no queda claro en el enunciado si hay que aumentar la potencia igualemente aunque no se cumpla el patrón, o si, en el caso de que el público esté originalmente exaltado, debe pasarse a estado no exaltado o si no le afecta, de todas formas la lógica es la misma. En estos casos lo mejor es tomar la decisión y explicarla con un comentario o preguntarle al profesor

aumentarPotencia :: Float -> PuestaEnEscena -> PuestaEnEscena
aumentarPotencia porcentaje puestaEnEscena = puestaEnEscena {potencia = potencia puestaEnEscena * (1+porcentaje/100)}

exaltarPublico :: PuestaEnEscena -> PuestaEnEscena
exaltarPublico puestaEnEscena = puestaEnEscena {publicoExaltado = True}

puestaBase :: PuestaEnEscena
puestaBase = PuestaEnEscena {
    publicoExaltado = False,
    potencia = 1,
    estrofa = [],
    estilo = id
}

tirarUnFreestyle :: Estrofa -> Estilo -> PuestaEnEscena
tirarUnFreestyle estrofa estilo = estilo (puestaBase {estrofa = estrofa,  estilo = estilo})

--Jurados
type Criterio = PuestaEnEscena -> Float
data Jurado = Jurado {
    criterios :: [Criterio],
    puntajeOtorgado :: Puntaje
}

type Puntaje = Float

alToke :: Jurado
alToke = Jurado {
    criterios = [criterioPatronAABB],
    puntajeOtorgado = 0
}

criterioPatronAABB :: Criterio
criterioPatronAABB puestaEnEscena
    | patronAABB (estrofa puestaEnEscena) = 0.5
    | otherwise = 0

criterioPatronCombinado :: Criterio
criterioPatronCombinado puestaEnEscena
    | patronCombina2 patronEsdrujula (patronSimple 1 4) (estrofa puestaEnEscena) = 1
    | otherwise = 0

criterioPublicoExaltado :: Criterio
criterioPublicoExaltado puestaEnEscena
    | publicoExaltado puestaEnEscena = 1
    | otherwise = 0

criterioPotencia :: Criterio
criterioPotencia puestaEnEscena
    | potencia puestaEnEscena > 1.5 = 2
    | otherwise = 0

juzgar :: Jurado -> PuestaEnEscena -> Float
juzgar jurado puestaEnEscena = puntajeOtorgado (foldl aumentarPuntaje (jurado) (map ($ puestaEnEscena) (criterios jurado)))

aumentarPuntaje :: Jurado -> Float -> Jurado
aumentarPuntaje jurado aumento
    | aumento + puntajeOtorgado jurado >= 3 = jurado {puntajeOtorgado = 3}
    | otherwise = jurado

--Bonus
data ArtistaBatallante = ArtistaBatallante {
    artista :: Artista,
    puestas :: [PuestaEnEscena]
}

type Batalla = ArtistaBatallante -> ArtistaBatallante -> [Jurado] -> ArtistaBatallante
batalla :: Batalla
batalla artista1 artista2 jurados
    | gana artista1 artista2 jurados = artista1
    | gana artista2 artista1 jurados = artista2

gana :: ArtistaBatallante -> ArtistaBatallante -> [Jurado] -> Bool
gana artista1 artista2 jurados = sum (map (juzgar (justiciaTotal jurados)) (puestas artista1)) > sum (map (juzgar (justiciaTotal jurados)) (puestas artista2))

justiciaTotal :: [Jurado] -> Jurado
justiciaTotal jurado = Jurado {
    criterios = concat (map (criterios) jurado),
    puntajeOtorgado = 0
}
