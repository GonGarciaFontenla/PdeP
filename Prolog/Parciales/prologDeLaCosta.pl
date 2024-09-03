%enunciado: https://docs.google.com/document/d/107Nr9xqhqGqGBLCqv-VKJR3wQAoGj131YBe7ygzJ7EY/edit#heading=h.6rnhl8528rg3

%Punto 1:
%puestos de comida:
%puestoDeComida(Comida, Precio).
puestoDeComida(hamburguesa, 2000).
puestoDeComida(panchitoConPapas, 1500).
puestoDeComida(lomitoCompleto, 2500).
puestoDeComida(caramelos, 0).

%atracciones:
%atrracion(nombre, functorCaracteristico(Car1,Car2,Car3,...)).

%atrraccion(nombre, tranquila(publicoAdmitido)).
atrracion(autitosChocadores, tranquila(todoPublico)).
atrracion(casaEmbrujada, tranquila(todoPublico)).
atrracion(laberinto, tranquila(todoPublico)).
atrracion(tobogan, tranquila(exclusivoChicos)).
atrracion(calesita, tranquila(exclusivoChicos)).

%atraccion(nombre, intensa(coeficienteDeLanzamiento)).
atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

%atrracion(nombre, montaniaRusa(cantidadDeGirosInvertidos, duracionEnSegundos)).
atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).

%atraccion(nombre, acuatica()).
atraccion(elTorpedoSalpicon, acuatica()).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa, acuatica()).

%visitantes:
%visitante(nombre, datosSuperficiales(edad, dinero), animo(hambre, aburrimiento)).
%luego haré un predicado que los relacione según su grupo
%y por principio de universo cerrado, si no están en ese predicado, significará que vinieron solos

visitante(eusebio, datosSuperficiales(80, 3000), animo(50, 0)).
visitante(carmela, datosSuperficiales(80, 30000), animo(0, 25)).
visitante(berty, datosSuperficiales(20, 2000), animo(0, 0)).
visitante(santiago, datosSuperficiales(14, 1000), animo(20, 50)).

%grupo(Visitante, Grupo) -> recibe un visitante y lo relaciona con su grupo
grupo(eusebio, viejitos).
grupo(carmela, viejitos).

%Punto 2:
%estados de ánimo
estadoDeAnimo(Visitante, Hambre, Aburrimiento) :-
    visitante(Visitante, _, animo(Hambre, Aburrimiento)).

sumaAnimo(Hambre, Aburrimiento, Suma) :-
    Suma is Hambre + Aburrimiento.

obtenerSumaAnimo(Visitante, Suma) :-
    estadoDeAnimo(Visitante, Hambre, Aburrimiento),
    sumaAnimo(Hambre, Aburrimiento, Suma).

sumaEntre(Suma, LimiteInferior, LimiteSuperior) :-
    Suma >= LimiteInferior,
    Suma =< LimiteSuperior.

vieneAcompaniado(Visitante) :-
    grupo(Visitante, _).

vieneSolo(Visitante) :-
    visitante(Visitante),
    not(vieneAcompaniado(Visitante)).

visitante(Visitante) :-
    visitante(Visitante, _, _).

felicidadPlena(Visitante) :-
    vieneAcompaniado(Visitante),
    estadoDeAnimo(Visitante, 0, 0).

podriaEstarMejor(Visitante) :-
    vieneSolo(Visitante),
    obtenerSumaAnimo(Visitante, Suma),
    sumaEntre(Suma, 0, 50).

podriaEstarMejor(Visitante) :-
    vieneAcompaniado(Visitante),
    obtenerSumaAnimo(Visitante, Suma),
    sumaEntre(Suma, 1, 50).

necesitaEntretenerse(Visitante) :-
    obtenerSumaAnimo(Visitante, Suma),
    sumaEntre(Suma, 51, 99).

quiereIrACasa(Visitante) :-
    obtenerSumaAnimo(Visitante, Suma),
    Suma >= 100.

%Punto 3:

satisface(hamburguesa, Visitante) :-
    estadoDeAnimo(Visitante, Hambre, _),
    Hambre < 50.

satisface(panchitoConPapas, Visitante) :-
    esChico(Visitante).

satisface(lomitoCompleto, Visitante) :-
    visitante(Visitante).

satisface(caramelos, Visitante) :-
    noPuedeComprarOtraCosa(Visitante).

edad(Visitante, Edad) :-
    visitante(Visitante, datosSuperficiales(Edad, _), _).

esChico(Visitante) :-
    edad(Visitante, Edad),
    Edad < 13.

dinero(Visitante, Dinero) :-
    visitante(Visitante, datosSuperficiales(_, Dinero), _).

puedeComprar(Visitante, Comida) :-
    dinero(Visitante, Dinero),
    puestoDeComida(Comida, Precio),
    Dinero >= Precio.

comidaConPrecio(Comida) :-
    puestoDeComida(Comida, _),
    Comida \= caramelos.

noPuedeComprarOtraCosa(Visitante) :-
    visitante(Visitante),
    forall(comidaConPrecio(Comida), not(puedeComprar(Visitante, Comida))).

puedeComprarYLoSatisface(Comida, Visitante) :-
    comidaConPrecio(Comida),
    visitante(Visitante),
    puedeComprar(Visitante, Comida),
    satisface(Comida, Visitante).

puedeComprarYLoSatisface(caramelos, Visitante) :-
    satisface(caramelos, Visitante).

comida(Comida) :-
    puestoDeComida(Comida, _).

grupo(Grupo) :-
    grupo(_, Grupo).

compraSatisfaceAlGrupo(Comida, Grupo) :-
    comida(Comida),
    grupo(Grupo),
    forall(grupo(Visitante, Grupo), puedeComprarYLoSatisface(Comida, Visitante)).

%Punto 4:
lluviaDeHamburguesas(Visitante, Atraccion) :-
    puedeComprar(Visitante, hamburguesa),
    veritiginosa(Atraccion, Visitante).

veritiginosa(Atraccion, _) :-
    atraccion(Atraccion, intensa(CoeficienteDeLanzamiento)),
    CoeficienteDeLanzamiento > 15.

veritiginosa(tobogan, Visitante) :-
    visitante(Visitante).

veritiginosa(Atraccion, Visitante) :-
    atraccion(Atraccion, montaniaRusa(_, _)),
    peligrosaPara(Atraccion, Visitante).

peligrosaPara(Atraccion, Visitante) :-
    esChico(Visitante),
    atraccion(Atraccion, montaniaRusa(_, DuracionEnSegundos)),
    DuracionEnSegundos > 60.

peligrosaPara(Atraccion, Visitante) :-
    not(esChico(Visitante)),
    not(necesitaEntretenerse(Visitante)),
    masGirosInvertidosEnTodoElParque(Atraccion).

masGirosInvertidosEnTodoElParque(Atraccion) :-
    atraccion(Atraccion, montaniaRusa(CantidadDeGirosInvertidos, _)),
    atraccion(_, montaniaRusa(OtraCantidadDeGirosInvertidos, _)),
    CantidadDeGirosInvertidos >= OtraCantidadDeGirosInvertidos.

%Punto 5:
opcionesDeEntretenimiento(Visitante, MesDeVisita, Opciones) :-
    findall(Opcion, opcionDeEntretenimiento(Visitante, MesDeVisita, Opcion), Opciones).

opcionDeEntretenimiento(Visitante, _, PuestoDeComida) :-
    comida(PuestoDeComida),
    puedeComprar(Visitante, PuestoDeComida).

opcionDeEntretenimiento(Visitante, _, AtraccionTranquila) :-
    atraccion(AtraccionTranquila, tranquila(_)),
    puedeAcceder(AtraccionTranquila, Visitante).

puedeAcceder(_, Visitante) :-
    esChico(Visitante).

puedeAcceder(_, Visitante) :-
    not(esChico(Visitante)),
    hayUnChicoEnElGrupo(Visitante).

hayUnChicoEnElGrupo(Visitante) :-
    grupo(Visitante, Grupo),
    grupo(OtraPersona, Grupo),
    Visitante \= OtraPersona,
    esChico(OtraPersona).

opcionDeEntretenimiento(_, _, AtraccionIntensa) :-
    atraccion(AtraccionIntensa, intensa(_)).

opcionDeEntretenimiento(Visitante, _, MontaniaRusa) :-
    atraccion(MontaniaRusa, montaniaRusa(_,_)),
    not(peligrosaPara(MontaniaRusa, Visitante)).

opcionDeEntretenimiento(_, MesDeVisita, Atraccion) :-
    member(MesDeVisita, [septiembre, octubre, noviembre, diciembre, enero, febrero, marzo]),
    atraccion(Atraccion, acuatica()).