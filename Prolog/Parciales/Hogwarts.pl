%----------PARTE 1----------%
%Genero las casa para que la inversibilidad de los predicados. 
casa(gryffindor). 
casa(slytherin).
casa(ravenclaw). 
casa(hufflepuff).

%Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. Odiaría que el sombrero lo mande a Slytherin.
%Draco es sangre pura, y se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. Odiaría que el sombrero lo mande a Hufflepuff.
%Hermione es sangre impura, y se caracteriza por ser inteligente, orgullosa y responsable. No hay ninguna casa a la que odiaría ir. 
mago(harry, mestiza, [coraje, amistoso, orgullo, inteligencia]). 
mago(draco, pura, [inteligencia, orgullo]). 
mago(hermione, impura, [inteligencia, orgullo, responsabilidad]). 

odiariaIr(harry, slitherin). 
odiariaIr(draco, hufflepuff). 

%Para Gryffindor, lo más importante es tener coraje.
enCuenta(gryffindor, [coraje]). 
%Para Slytherin, lo más importante es el orgullo y la inteligencia.
enCuenta(slytherin, [orgullo, inteligencia]). 
%Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
enCuenta(ravenclaw, [inteligencia, responsabilidad]).
%Para Hufflepuff, lo más importante es ser amistoso.
enCuenta(hufflepuff, [amistoso]). 

%Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier 
%casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura.
permiteEntrar(Casa, Mago):-
    casa(Casa),
    mago(Mago, _, _),
    not((Casa = slytherin, mago(Mago, impura, _))). 

%Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características 
%incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.
caracterApropiado(Casa, Mago):-
    casa(Casa), 
    mago(Mago, _, CaractMago), 
    enCuenta(Casa, CaractCasa),
    forall(member(X, CaractCasa), member(X, CaractMago)). %X toma una de las caracteristicas de la casa y verifica que el mago la tenga. 

%Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, 
%la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada 
%en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.
seleccionado(Casa, Mago):-
    casa(Casa), 
    mago(Mago,_,_), 
    permiteEntrar(Casa, Mago), 
    caracterApropiado(Casa, Mago), 
    not(odiariaIr(Mago, Casa)). 

cadenaAmistados(Magos):-
    forall((member(Mago, Magos), mago(Mago, _, CaractMago)), member(amistoso, CaractMago)),
    mismaCasa(Magos).

mismaCasa([_]). 
mismaCasa([Mago1, Mago2 | Magos]):-
    seleccionado(Casa, Mago1), 
    seleccionado(Casa, Mago2), 
    mismaCasa([Mago2 | Magos]). 


%----------PARTE 2----------%
%Malas acciones: 
%Andar de noche fuera de la cama (que resta 50 puntos). 
%accion(fueraCama, -50). 
%Ir a lugares prohibidos: cantidad de puntos que se resta por ir a un lugar prohibido se indicará para cada lugar.
%accion(bosque, -50).
%accion(biblioteca, -10).
%accion(tercerPiso, -75). 

%Buenas acciones: 
%accion(ajedrez, 50). 
%accion(intelecto, 50).
%accion(ganarVoldemort, 60).



%Registrar las distintas acciones que hicieron los alumnos de Hogwarts durante el año.
%Harry anduvo fuera de cama, fue al bosque y al tercer piso y vencion a Voldemort. 
hizoAccion(harry, fueraCama).
hizoAccion(harry, irA(bosque)). 
hizoAccion(harry, irA(tercerPiso)).
hizoAccion(harry, buenaAccion(60, ganarVoldemort)). 
%Hermione fue al tercer piso, a la sección restringida de la biblioteca y salvo a sus amigos de una muerte horrible.
hizoAccion(hermione, irA(tercerPiso)).
hizoAccion(hermione, irA(biblioteca)). 
hizoAccion(hermione, buenaAccion(50, intelecto)). 
hizoAccion(hermione, responderPregunta(dondeSeEncuentraUnBezoar, 20, snape)).
hizoAccion(hermione, responderPregunta(comoHacerLevitarUnaPluma, 25, flitwick)).
%Draco fue a las mazmorras.
hizoAccion(draco, irA(mazmorras)).
%Ron gano una partida de ajedrez mágico.
hizoAccion(ron, buenaAccion(50, ajedrez)). 

%Puntajes que generan las acciones: 
puntajeAcciones(fueraCama, -50). 

puntajeAcciones(irA(Lugar), PuntajeQueResta):-
    lugarProhibido(Lugar, PuntajeQueResta),
    PuntajeQueResta is PuntajeQueResta. 

puntajeAcciones(buenaAccion(Puntaje, _), Puntaje). 

puntajeAcciones(responderPregunta(_, Dificultad, snape), Puntos):-
    Puntos is Dificultad // 2. 

puntajeAcciones(responderPregunta(_, Dificultad, Profesor), Dificultad):-
    Profesor \= snape. 

%Lugares prohibidos
lugarProhibido(bosque, -50).
lugarProhibido(biblioteca, -10).
lugarProhibido(tercerPiso, -75).

%predicado esDe/2 que relaciona a la persona con su casa.
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

%Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción.
esBuenAlumno(Mago):-
    esDe(Mago, _), %Por tema de inversibilidad. Se podria hacer varios hechos de solo los magos, pero tomo este que ya esta dado por la consigna. 
    forall((hizoAccion(Mago, Accion), puntajeAcciones(Accion, Puntaje)), Puntaje >= 0). 

%Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
accionRecurrente(Accion):-
    hizoAccion(Mago1, Accion), 
    hizoAccion(Mago2, Accion), 
    Mago1 \= Mago2. 

%Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
puntajeTotal(Casa, PuntajeTotal):-
    esDe(_,Casa),
    findall(Puntaje, (esDe(Mago, Casa), hizoAccion(Mago, Accion), puntajeAcciones(Accion, Puntaje)), Puntajes),
    sum_list(Puntajes, PuntajeTotal).

%Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.
casaGanadora(CasaGanadora):-
    casa(CasaGanadora), 
    puntajeTotal(CasaGanadora, PuntajeGanador),
    not((casa(OtraCasa),
        OtraCasa \= CasaGanadora, 
        puntajeTotal(OtraCasa, PuntajeOtro), 
        PuntajeOtro >= PuntajeGanador)). %En caso de empate, no hay ninguna casa ganadora. 

