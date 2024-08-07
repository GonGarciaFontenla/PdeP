module Library where
import PdePreludat
import Data.Char (toLower)
import Data.Int (Int)
import Data.Char (toUpper)

----------PRIMERA PARTE
---------------------------------------------------PUNTO 1------------------------------------------------
--a
data Persona = UnaPersona{
    edad::Number,
    items::[String],
    experiencia::Number
}

data Criatura = UnaCriatura{
    cantidadOCategoria::Number,
    comoVencerlo::(Persona->Bool),
    peligrosidad::Number
}

--b
siempreDetras::Criatura
siempreDetras = UnaCriatura 1000 esInvencible 0

esInvencible::Persona->Bool
esInvencible persona = False

--c
gnomos::Number->Criatura
gnomos cantidad = UnaCriatura cantidad (tiene "Soplador de hojas")  (2 ^ cantidad)

tiene::String->Persona->Bool
tiene objeto persona = (elem objeto . items) persona

--d
fantasma::Number->(Persona->Bool)->Criatura
fantasma categoria requisito = UnaCriatura categoria requisito (20 * categoria)

---------------------------------------------------PUNTO 2------------------------------------------------
seEnfrentaA::Persona -> Criatura -> Persona
seEnfrentaA persona criatura 
    | persona `puedeVencerA` criatura = ganaXP persona (peligrosidad criatura)
    | otherwise = ganaXP persona 1

ganaXP::Persona->Number->Persona
ganaXP persona cantidad = persona {experiencia = (experiencia persona) + cantidad}

puedeVencerA::Persona->Criatura->Bool
puedeVencerA persona criatura = comoVencerlo criatura $ persona 

---------------------------------------------------PUNTO 3------------------------------------------------
--a
luegoDePelearGana::Persona->[Criatura]->Persona
luegoDePelearGana persona criaturas = foldl seEnfrentaA persona criaturas

--b
criaturasDePrueba =
     [siempreDetras, gnomos 10, fantasma 3 (\persona->tiene "Disfraz de oveja" persona && edad persona < 13), fantasma 1 ((10<).experiencia) ]


----------SEGUNDA PARTE
---------------------------------------------------PUNTO 1------------------------------------------------
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]  
zipWithIf funcion condicion _ [] = []
zipWithIf funcion condicion (a1:as) (b1:bs) 
    | condicion b1 = funcion a1 b1 : zipWithIf funcion condicion as bs    
    | otherwise = b1 : zipWithIf funcion condicion (a1:as) bs

---------------------------------------------------PUNTO 2------------------------------------------------
abecedario::[Char]
abecedario = ['a'..'z'] ++ ['A'..'Z']

--a 
abecedarioDesde :: Char -> [Char]
abecedarioDesde letra = init ([letra..'z'] ++ ['a'..letra]) ++ init ([toUpper(letra)..'Z'] ++ ['A'..toUpper(letra)])

--b
desencriptarLetra :: Char -> Char -> Char
desencriptarLetra clave reemplazar
    | esUnaLetra reemplazar = abecedario !! ((retornarPosicion reemplazar . abecedarioDesde) clave)
    | otherwise = reemplazar

esUnaLetra::Char->Bool
esUnaLetra letra = elem letra abecedario

retornarPosicion::Char->[Char]->Number
retornarPosicion letra (x:yz) 
    | x == letra = 0
    | otherwise = 1 + retornarPosicion letra yz

--c
cesar :: Char -> [Char] -> [Char]
cesar clave textoEncriptado = zipWithIf desencriptarLetra esUnaLetra (repeat clave) textoEncriptado
--cesar clave textoEncriptado = map (desencriptarLetra clave) textoEncriptado--> OTRA ALTERNATIVA

--d
todasLasConsultas::[String]
todasLasConsultas = map (flip cesar "Jrzel Zrfaxal!") abecedario

---------------------------------------------------PUNTO 3------------------------------------------------
vigenere::[Char]->[Char]->[Char]               
vigenere palabraClave mensajeOriginal= zipWithIf desencriptarLetra esUnaLetra ((concat . repeat) palabraClave) mensajeOriginal
