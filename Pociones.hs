module Pociones where

data Persona = Persona {
  nombrePersona :: String,
  suerte :: Int,
  inteligencia :: Int,
  fuerza :: Int
} deriving (Show, Eq)

data Pocion = Pocion {
  nombrePocion :: String,
  ingredientes :: [Ingrediente]
}

type Efecto = Persona -> Persona

data Ingrediente = Ingrediente {
  nombreIngrediente :: String,
  efectos :: [Efecto]
}

nombresDeIngredientesProhibidos = [
 "sangre de unicornio",
 "veneno de basilisco",
 "patas de cabra",
 "efedrina"]

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [ x ] = x
maximoSegun  f ( x : y : xs)
  | f x > f y = maximoSegun f (x:xs) --X es mayor --> Sigue siendo la cabeza de la lista
  | otherwise = maximoSegun f (y:xs) --X es menor --> Y pasa a ser la cabeza de la lista

--Solucion
niveles :: Persona -> [Int]
niveles persona = map ($ persona) niveles'

niveles' = [fuerza, suerte, inteligencia]

sumaDeNiveles :: Persona -> Int
sumaDeNiveles= sum . niveles

diferenciaDeNiveles :: Persona -> Int
diferenciaDeNiveles persona = maximoNivel persona - minimoNivel persona
maximoNivel = maximum . niveles
minimoNivel = minimum . niveles

nivelesMayoresA :: Int -> (Persona -> Int)
nivelesMayoresA numero = length . filter(>numero) . niveles

efectosDePocion :: Pocion -> [Efecto]
efectosDePocion = concat . map efectos . ingredientes

pocionHardcore :: [Pocion] -> [String]
pocionHardcore = map nombrePocion . filter ( (>=4) . length . efectosDePocion)

cantidadDePocionesProhibidas :: [Pocion] -> Int
cantidadDePocionesProhibidas = length . filter esProhibida

esProhibida :: Pocion -> Bool
esProhibida = any (flip elem nombresDeIngredientesProhibidos . nombreIngrediente) . ingredientes

todasDulces :: [Pocion] -> Bool
todasDulces =  all ( any (( "azucar" == ) .nombreIngrediente) . ingredientes)

tomarPocion :: Pocion -> Persona -> Persona
tomarPocion pocion personaI =
    (foldl (\persona efecto -> efecto persona) personaI . efectosDePocion ) pocion

esAntidotoDe :: Pocion -> Pocion -> Persona -> Bool
esAntidotoDe pocionI pocionII persona =
    ((==persona) . tomarPocion pocionII . tomarPocion pocionI) persona

personaMasAfectada :: Pocion -> (Persona -> Int) -> ([Persona] -> Persona)
personaMasAfectada pocion criterio = maximoSegun (criterio . tomarPocion pocion)
