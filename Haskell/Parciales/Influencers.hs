module Library where
import PdePreludat

-- ------------------------- Dominio --------------------------

data Persona = UnaPersona {
    gustos :: [Gusto],
    miedos :: [Miedo],
    estabilidad :: Estabilidad
    } deriving (Show)

-- ------------------------- Definición de Tipos --------------------------
type Gusto = String
type Miedo = (String, Number)
type Estabilidad = Number

type Accion = Persona -> Persona
type Influencer = Persona -> Persona
type Condicion = Persona -> Bool
type Producto = (Gusto, Condicion)

-- ------------------------- Modelaje (Ejemplos) --------------------------
-- --------------- Personas
maria :: Persona
maria = UnaPersona {
    gustos = ["Mecanica"],
    miedos = [("Extraterrestres", 600), ("Quedarse sin trabajo", 300)], 
    estabilidad = 85
    }

juanCarlos :: Persona
juanCarlos = UnaPersona {
    gustos = ["Maquillaje", "Trenes"],
    miedos = [("Insectos", 100), ("Coronavirus", 10), ("Vacunas", 20)], 
    estabilidad = 50
    }

-- --------------- Productos
desodoranteAcks :: Producto
desodoranteAcks = ("Chocolate", estabilidadMenorA 50)

llaveroPlatoVolador :: Producto
llaveroPlatoVolador = ("Extraterrestres", not . esMiedosa)

polloFritoCeEfeSe :: Producto 
polloFritoCeEfeSe = ("Frito", esFanaticaDe "Pollo")

-- ------------------------- Funciones Genericas --------------------------
-- ----------------- Personas
gustosSegunF :: ([Gusto] -> [Gusto]) -> Persona -> Persona
gustosSegunF f persona = persona {gustos = f . gustos $ persona}

miedosSegunF :: ([Miedo] -> [Miedo]) -> Persona -> Persona
miedosSegunF f persona = persona {miedos = f . miedos $ persona}

estabilidadSegunF :: (Estabilidad -> Estabilidad) -> Persona -> Persona
estabilidadSegunF f persona = persona {estabilidad = escala . f . estabilidad $ persona}

escala :: Number -> Number
escala = min 100 . max 0

-- ----------------- Miedos
nombreMiedos :: [Miedo] -> [String]
nombreMiedos = map fst

cantMiedoSegunF :: (Number -> Number) -> Miedo -> Miedo
cantMiedoSegunF f (nombre, cant) = (nombre, f cant)

-- ----------------- Cualquiera
encontrarAlgo :: (a -> Bool) -> a ->  [a] -> a
encontrarAlgo cond gusto = head . filter cond

-- ------------------------- Funciones --------------------------
-- ---------------- Parte 1
-- Funcion 1
hacerMiedosa :: Miedo -> Accion
hacerMiedosa miedo = miedosSegunF (agregarMiedo miedo)

agregarMiedo :: Miedo -> [Miedo] -> [Miedo]
agregarMiedo miedo miedos = 
    nuevoMiedo miedo miedos : miedosSin miedo miedos

nuevoMiedo :: Miedo -> [Miedo] -> Miedo
nuevoMiedo miedo miedos
    | estaMiedo miedo miedos = cantMiedoSegunF (+ snd miedo) (encontrarMiedo miedo miedos)
    | otherwise = miedo 

estaMiedo :: Miedo -> [Miedo] -> Bool
estaMiedo miedo miedos = elem (fst miedo) (nombreMiedos miedos) 

encontrarMiedo :: Miedo -> [Miedo] -> Miedo
encontrarMiedo miedo = encontrarAlgo ((fst miedo ==) . fst) miedo

miedosSin :: Miedo -> [Miedo] -> [Miedo]
miedosSin miedo = filter ((fst miedo /=) . fst)

-- Funcion 2
perderMiedo :: String -> Accion
perderMiedo nombreMiedo = miedosSegunF (miedosSin (nombreMiedo, 0))

-- Funcion 3
variarEstabilidad :: (Estabilidad -> Estabilidad) -> Accion
variarEstabilidad = estabilidadSegunF

-- Funcion 4
volverseFan :: Persona -> Accion
volverseFan famoso = gustosSegunF (copiarGustos famoso)

copiarGustos :: Persona -> [Gusto] -> [Gusto]
copiarGustos famoso gustosFan = gustos famoso ++ gustosFan

-- Funcion 5
esFanaticaDe :: Gusto -> Persona -> Bool
esFanaticaDe gusto = (>3) . length . encontrarGustos gusto . gustos 

encontrarGustos :: Gusto -> [Gusto] -> [Gusto]
encontrarGustos gusto = filter (gusto ==) 

-- Funcion 6
esMiedosa :: Persona -> Bool
esMiedosa = (>1000) . sum . map snd . miedos

-- ---------------- Parte 2
aplicarAcciones :: Persona -> [Accion] -> Persona
aplicarAcciones = foldr ($) 

-- Funcion 1
elin :: Influencer
elin = flip aplicarAcciones accionesElin

accionesElin :: [Accion]
accionesElin = [
    estabilidadSegunF (subtract 20) , 
    hacerMiedosa ("Extraterrestres", 100) , 
    hacerMiedosa ("Coronavirus", 50)
    ]

-- Funcion 2
miedoCorrupcion :: Influencer
miedoCorrupcion = flip aplicarAcciones accionesCorrupcion

accionesCorrupcion :: [Accion]
accionesCorrupcion = [    
    hacerMiedosa ("Corrupcion", 100), 
    perderMiedo "Convertirse en Venezuela",
    gustosSegunF ("Escuchar" :)
    ]

-- Funcion 3
communityManager :: Persona -> Influencer
communityManager = volverseFan

-- Funcion 4
influencerInutil :: Influencer
influencerInutil = id

-- Funcion 5
terraplanista :: Influencer
terraplanista = flip aplicarAcciones accionesTerraplanista

accionesTerraplanista :: [Accion]
accionesTerraplanista = [
    hacerMiedosa ("Corrupcion", 500),
    hacerMiedosa ("Conspiraciones", 100),
    perderMiedo "Decir boludeces",
    estabilidadSegunF (subtract 300)
    ] 

-- Funcion 6
campaniaMarketing :: Influencer -> [Persona] -> [Persona]
campaniaMarketing = map 

-- Funcion 7
cualGeneraMasMiedo :: [Persona] -> Influencer -> Influencer -> Influencer
cualGeneraMasMiedo personas i1 i2
    | generaMasMiedo personas i1 i2 = i1
    | otherwise = i2

generaMasMiedo :: [Persona] -> Influencer -> Influencer -> Bool
generaMasMiedo personas i1 i2 = cantMiedosos i1 personas >= cantMiedosos i2 personas

cantMiedosos :: Influencer -> [Persona] -> Number
cantMiedosos influencer personas =
    length . filter esMiedosa $ campaniaMarketing influencer personas

-- ---------------- Parte 3

estabilidadMenorA :: Number -> Persona -> Bool
estabilidadMenorA delta = (<delta) . estabilidad

eficienciaCampanniaMarketing :: Producto -> Influencer -> [Persona] -> Number
eficienciaCampanniaMarketing prod inf personas = diffCompradores prod inf personas / 100 
    
diffCompradores :: Producto -> Influencer -> [Persona] -> Number
diffCompradores prod inf personas = 
    cantPostMarketing prod inf personas - cantCompranProd prod personas

cantPostMarketing :: Producto -> Influencer -> [Persona] -> Number
cantPostMarketing prod inf personas = 
    cantCompranProd prod (campaniaMarketing inf personas) 

cantCompranProd :: Producto -> [Persona] -> Number
cantCompranProd producto = length . filter (comprariaProducto producto)

comprariaProducto :: Producto -> Persona -> Bool
comprariaProducto (gusto, cond) persona = elem gusto (gustos persona) && cond persona