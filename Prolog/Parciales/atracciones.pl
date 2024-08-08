%%------------PARQUE DE ATRACCIONES------------%%
%De cada persona, conocemos su edad y altura, aquí van algunos ejemplos:
%Nina es una joven de 22 años y 1.60m.
persona(nina, joven, 22, 1.60).
%Marcos es un niño de 8 años y 1.32m. 
persona(marcos, niño, 8, 1.32). 
%Osvaldo es un adolescente de 13 años y 1.29m.
persona(osvaldo, adolescente, 13, 1.29). 

 
%Tren Fantasma: exige que la persona sea mayor o igual a 12 años.
atraccion(parqueCosta, trenFantasma, 12, 0). 
%Montaña Rusa: exige que la persona tenga más de 1.30 de altura.
atraccion(parqueCosta, montanaRusa,0 , 1.30). 
%Máquina Tiquetera: no tiene exigencias.
atraccion(parqueCosta, maquinaTiquetera,0 ,0). 
%Tobogán Gigante "La Ola Azul": altura mínima 1.50m
atraccion(parqueAcuatico, olaAzul,0 , 1.50). 
%Río Lento "Corriente Serpenteante": sin requisitos.
atraccion(parqueAcuatico, corrienteSerpenteante,0 ,0). 
%Piscina de Olas "Maremoto": mínimo 5 años
atraccion(parqueAcuatico, maremoto, 5, 0). 

%Pasaportes. 
pasaporte(nina, basico, 20). 
pasaporte(marcos, flex(juegoPermitido(maquinaTiquetera)), 15). 
pasaporte(osvaldo, premium, _). 

%Juegos. 
juegoComun(trenFantasma, 20). 
juegoComun(olaAzul, 10). 
juegoComun(maremoto, 30). 
juegoComun(montanaRusa, 15). 

juegoPremium(maquinaTiquetera). 
juegoPremium(corrienteSerpenteante). 

%puedeSubir/2, relaciona una persona con una atracción, si la persona puede subir a la atracción.
puedeSubir(Persona, Atraccion):- 
    persona(Persona,_, Edad, Altura), 
    atraccion(_, Atraccion, EdadMin, AlturaMin), 
    Edad >= EdadMin, 
    Altura >= AlturaMin,
    tieneAcceso(Persona, Atraccion). 

tieneAcceso(Persona, Atraccion):-
    pasaporte(Persona, basico, Creditos), 
    juegoComun(Atraccion, Costo), 
    Creditos >= Costo. 

tieneAcceso(Persona, Atraccion):- 
    pasaporte(Persona, flex(Permitido), Creditos), 
    (juegoComun(Atraccion, Costo), Creditos >= Costo;
    juegoPremium(Atraccion), Permitido = juegoPermitido(Atraccion)). 

tieneAcceso(Persona, _):-
    pasaporte(Persona, premium, _).

%esParaElle/2, relaciona un parque con una persona, si la persona puede subir a todos los juegos del parque.
esParaElle(Persona, Parque):-
    persona(Persona, _, _,_), 
    atraccion(Parque, _, _, _),
    forall(atraccion(Parque, Atraccion, _, _), puedeSubir(Persona,Atraccion)). 

%malaIdea/2, relaciona un grupo etario (adolescente/niño/joven/adulto/etc) con un parque, y nos dice que "es mala idea" 
%que las personas de ese grupo vayan juntas a ese parque, si es que no hay ningún juego al que puedan subir todos.
malaIdea(GrupoEtario, Parque):-
    persona(_, GrupoEtario, _, _), 
    forall(persona(Persona, GrupoEtario, _, _), not(puedeSubirAunaAtraccion(Persona, Parque))).

puedeSubirAunaAtraccion(Persona, Parque):- 
    atraccion(Parque, Atraccion, _, _),
    puedeSubir(Persona, Atraccion). 

%%------------PROGRAMAS------------%%
%Un programa es una lista ordenada de atracciones, que tienen que estar todas en el mismo parque.
programa([olaAzul, maremoto, corrienteSerpenteante]). 
programa([olaAzul, corrienteSerpenteante, maremoto]).
programa([olaAzul, trenFantasma, maremoto]). 
programa([trenFantasma, montanaRusa, maquinaTiquetera, trenFantasma]).
programa([trenFantasma, montanaRusa]).

%programaLogico/1, me dice si un programa es "bueno", es decir, todos los juegos están en el mismo parque y no hay juegos repetidos.
programaLogico(Programa):-
    programa(Programa), 
    programaEnUnParque(Programa), 
    sinRepetidos(Programa). 

programaEnUnParque([Atraccion|RestoAtracciones]):-
    atraccion(Parque, Atraccion, _, _), 
    forall(member(A,RestoAtracciones), atraccion(Parque, A, _,_)). 

sinRepetidos([]). 
sinRepetidos([Head|Tail]):- 
    not(member(Head, Tail)), 
    sinRepetidos(Tail). 

%hastaAca/3, relaciona a una persona P y un programa Q, con el subprograma S que se compone de las atracciones iniciales 
%de Q hasta la primera a la que P no puede subir (excluida obviamente).
hastaAca(Persona, Programa, AtraccionesValidas):-
    persona(Persona, _, _, _), 
    programa(Programa), 
    hastaQueNoPuedaSubir(Persona,Programa,AtraccionesValidas). 

hastaQueNoPuedaSubir(_, [], []). 

hastaQueNoPuedaSubir(Persona,[Atraccion|RestoAtracciones],Atraccion|Atracciones):-
    puedeSubir(Persona,Atraccion), 
    hastaQueNoPuedaSubir(Persona,RestoAtracciones,Atracciones).

hastaQueNoPuedaSubir(Persona, [Atraccion|_], []):-
    not(puedeSubir(Persona, Atraccion)).
