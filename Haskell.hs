
module Haskell where

--doble: Dado un valor entero, retorna el doble del valor
doble :: Int -> Int
doble numero = 2 * numero

-- esMayor: dada una edad da true si es mayor o igual a 18
esMayor :: Int -> Bool
esMayor edad = edad >= 18

--esMenor: dada una edad da true si es menor o igual a 18
esMenor :: Int -> Bool
esMenor edad = not (esMayor edad) --niego la funcion esMayor

--nombreFormateado: dado un nombre y un apellido, retorna el nombre completo en el formato: "Apellido, nombre"
nombreFormateado :: String -> String -> String
nombreFormateado nombre apellido = apellido ++ "," ++ nombre

--conjuncion: dado dos valores booleanos, evalua la conjuncion y retornea True o False
conjuncion :: Bool -> Bool -> Bool
conjuncion True True = True
conjuncion _ _ = False

--f: Si se ingresa 0 devuelve 1, si se ingresa cualquier otro numero devuelve el doble
f :: Int -> Int
f 0 = 1
f n = n * 2

--g: Guardas
g :: Int -> Int
g x
   | x < -1 = -1
   | -1 <= x && x <= 1 = 1
   | x > 1 = -1

--o: Otherwise
o :: Int -> Int
o x
   |x < -1 = -1
   |x > 1 = 1
   |otherwise = 0

--factorial: Dado un entero, retorna el factorial de ese numero
factorial :: Int -> Int
factorial 0 = 1 --caso base
factorial n --caso recursivo --> para conocer el factorial de un numero, tengo que conocer el factorial de otro.
   | n > 0 = n * factorial(n-1)

--identidad: Funcion identidad --> dado un valor. retorna ese mismo valor
identidad :: a -> a --variable de tipo
identidad x = x

--aprobo: Dado un alumno, retorna True si aprobo el examen.
data Estudiante = UnEstudiante {
    nombre :: String,
    legajo :: String,
    nota :: Int
}deriving (Show,Eq)

gonzalo :: Estudiante
gonzalo = UnEstudiante "Gonzalo" "1234" 9

santiago :: Estudiante
santiago = UnEstudiante "Santiago" "5678" 4

aprobo :: Estudiante -> Bool
aprobo estudiante
    = nota estudiante >= 6

--legajoYnombre: Dado un estudiante retorna el nombre y legajo.
legajoYnombre :: Estudiante -> String
legajoYnombre (UnEstudiante legajo nombre _) = legajo ++ " " ++ nombre

--leFueMejor: Compara entre las notas de dos alumnos y retorna cual fue el que obtuvo mejores notas
leFueMejor :: Estudiante -> Estudiante -> Bool
leFueMejor (UnEstudiante _ _  mejorNota) (UnEstudiante _ _ otraNota)
 =mejorNota > otraNota

--truncar: a partir de una cierta cant. de caracteres y una palabra, trunca la palabra e informa los primeros
-- caracteres de la palabra y cuantos caracteres se descartaron.
truncar :: Int -> String -> (String, Int)
truncar cantidadCaracteres palabra
 = (take cantidadCaracteres palabra, length palabra - cantidadCaracteres)--tupla de dos componentes

--mayor: recibe una edad y retorna True si es mayor a 18 --> Defino funcion en termino de otra
type Edad = Int --Utilizo alias de tipo
mayor :: Edad -> Bool
mayor = (>=18)

--dobles:recibe un numero y retorna el doble --> Defino funcion en termino de otra
dobles :: Num a => a -> a
dobles = (2 *)

--alMenosCero: Recibe un numero, retorna 0 si el numero es negativo y el mismo numero si es positivo
alMenosCero :: (Num a, Ord a) => a -> a
alMenosCero = max 0

--minimoCero:misma funcion que anterior pero si utilizar la funcion max
--hago esta funcion con el objetivo de mostrar la simplicidad de utilizar otras funciones a la hora
-- de definir funciones
minimoCero ::(Num a, Ord a) => a -> a
minimoCero a
 |a > 0 = a
 |otherwise = 0

--mulSum: recibe dos valores y retorna el ultimo valor multiplicado por 2 y sumado con el primero
mulSum :: Int -> Int -> Int
--mulSum a b = ((+ a) . (*2)) b
--mulSum a b = (+ a) . (*2) $ b
mulSum a = (+ a) . (*2)
--El codigo funciona de las 3 maneras.

--pfMax: Recibe dos valores y retorna el mayor
pfMax :: Ord a => a -> a -> a
--pfMax a b = max a b
--pfMax a = max a
pfMax = max
--El codigo funciona de las 3 maneras

--esMultiploDe: Recibe un divisor y un dividendo y retorna true si el resto de la division es cero. 
esMultiploDe :: Int -> Int -> Bool
esMultiploDe divisor numero = mod numero divisor == 0

--lambda: Expresion lambda --> Una forma de definir funciones
lambda :: Int -> Int -> Int
lambda = (\x y -> x + x * y)

--Ejemplo un poco mas complejo de expresion lambda
data Persona = Persona {
  name :: String,
  edad :: Int
} deriving (Show, Eq)

catalina :: Persona
catalina = Persona "Catalina" 19

soledad :: Persona
soledad = Persona "Soledad" 17
--manera convencional
adolescente :: Persona -> Bool
adolescente persona = edad persona >= 12 && edad persona <= 18
--usando expresion Lambda
adolescenteI :: Persona -> Bool
adolescenteI = (\anios -> anios >= 12 && anios <= 18).edad
--usando abstraccion
adolescenteII :: Persona -> Bool
adolescenteII = estaEntre 12 18.edad
estaEntre :: Ord a => a -> a -> a -> Bool
estaEntre inferior superior valor = valor >= inferior && valor <=superior
--estaEntre usando funcion currificada
estaEntreI :: Ord a => a -> (a -> (a -> Bool))
estaEntreI = (\inferior -> (\superior -> (\valor -> valor >= inferior && valor <= superior))) --es lo que hace Haskell internamente

--ORDEN SUPERIOR
--Consigna: I) Dado dos strings, retornar el de mayor longitud. II) Dado dos numeros, retornar el de mayor valor absoluto.
--III) Dadas dos personas, retornar la de mayor edad.
--Para poder realizar las 3 consignas en una sola funcion, debo generalizar.
elDeMayor :: Ord b => (a -> b) -> a -> a -> a
elDeMayor ponderacion x y --ponderacion = length / abs / edad
   |ponderacion x > ponderacion y = x
   |otherwise = y

--hacerNveces: Evaluar una funcion sucesivamente sobre un valor, tantas veces como se indique.
hacerNveces :: Int -> (a -> a) -> a -> a
hacerNveces 0 f valor = valor
hacerNveces n f valor | n > 0 = hacerNveces (n-1) f (f valor)

--LISTAS
type Alimento = String
--agregarAlimento: agrega alimentos a la lista de compras
agregarAlimento :: Alimento -> [Alimento] -> [Alimento]
agregarAlimento alimento listaDeCompras = alimento : listaDeCompras
--cantidadDeAlimentos: retorna la cantidad de alimentos que hay que comprar
cantidadDeAlimentos :: [Alimento] -> Int
cantidadDeAlimentos listaDeCompras = length listaDeCompras
--yaEstaEnLaLista: retorna True si un alimento ya esta en la lista
yaEstaEnLaLista :: Alimento -> [Alimento] -> Bool
yaEstaEnLaLista alimento listaDeCompras = elem alimento listaDeCompras

--todosPares:dado un conjunto de numeros, retorna True si todos los numeros son pares
todosPares :: [Int] -> Bool
todosPares [] = True
todosPares (numero:numeros)
   = even numero && todosPares numeros

--todosAprobados:dado un conjunto de estudiantes, retorna True si todos aprobaron
todosAprobados :: [Estudiante] -> Bool
todosAprobados [] = True
todosAprobados (estudiante:estudiantes)
   = aprobo estudiante && todosAprobados estudiantes

--GENERALIZACION:
--todosCumplen ya existe en Haskell y se llama *all*
todosCumplen :: (a -> Bool) -> [a] -> Bool
todosCumplen criterio [] = True
todosCumplen criterio (x:xs)
   = criterio x && todosCumplen criterio xs

todosPares' :: [Int] -> Bool
todosPares' = todosCumplen even

todosAprobados' :: [Estudiante] -> Bool
todosAprobados' = todosCumplen aprobo

todosCortos :: [String] -> Bool
todosCortos = todosCumplen ((<10).length)

{-alimentosPocoCaloricos: apartir de lista de tipo [InformacionNutricional] retorna que alimentos tienen menos 
de 100 calorias-}
data InformacionNutricional = Info{
   alimento :: Alimento,
   calorias :: Int,
   grasas :: Float,
   carbohidratos :: Float,
   proteinas :: Float
} deriving (Show, Eq)

infoManzana = Info "Manzana" 95 0.3 25.1 0.5
infoBanana = Info "Banana" 134 0.5 34.3 1.6
infoPera = Info "Pera" 100 0.2 27.1 0.6
infoEspinaca = Info "Espinaca" 7 0.1 1.1 0.9
infoYogurt = Info "Yogurt" 149 8.0 11.4 8.5
infoGarbanzos = Info "Garbanzos" 269 4.2 45.0 14.5

infosNutricionales = [
   infoManzana, infoBanana, infoPera,
   infoEspinaca, infoYogurt, infoGarbanzos
 ]

alimentosPocoCaloricos :: [InformacionNutricional] -> [Alimento]
alimentosPocoCaloricos = map alimento . filter pocoCalorico

pocoCalorico = (<=100).calorias

--GENERALIZACION: FOLDEO O REDUCCION
--declaracion de funcion lenght
length' :: [a] -> Int
length' [] = 0
length' (x:xs) = 1 + length' xs
--declaracion de funcion sum
sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs
--declaracion de funcion productoria
productoria :: Num a => [a] -> a
productoria [] = 1
productoria (x:xs) = x * productoria xs
{-Ambas tres funciones sigue la misma estructura, pero presentan algunas diferencias, por ende, no es posible
aplicar orden superior. Para lograr una generalizacion  se utiliza Fold-}
foldr' :: (b -> a -> a) -> a -> [b] -> a
foldr' f valor [] = valor
foldr' f valor (x:xs) = f x (foldr' f valor xs)

productoria' :: Num a => [a] -> a
productoria' = foldr (*) 1 --1 es el valor que retorna en caso de recibir una lista vacia.

length'' :: [a] -> Int
length'' = foldr (\_ x -> x+1) 0 

--maximum':Recibe algun dato y retorna el maximo
maximum' :: Ord a => [a] -> a
maximum' [x] = x
maximum' (x:xs) = x `max` (maximum' xs)

--foldr1: Uso concreto de foldr --> Solo trabajo con los elementos que forman parte de ese conjunto
--funcion predeterminada de Haskell
foldr1' :: (a -> a -> a) -> [a] -> a
foldr1' f lista = foldr f (last lista) (init lista)

