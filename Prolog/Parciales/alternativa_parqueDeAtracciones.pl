%enunciado: https://docs.google.com/document/d/139S8G0vwD5wJNfb8UqsH5BV75d7sfUk9ywdvFCXRcLI/edit#heading=h.b7fwzcvrhqzl

%Personas:
%persona(Nombre, Edad, Altura(En cm))
persona(nina, 22, 160).
persona(marcos, 8, 132).
persona(osvaldo, 13, 129).

persona(Persona) :-
    persona(Persona, _, _).

%Pasaporte:
%pasaporte(Persona, Pasaporte).
%pasaporte(Persona, basico(creditos)).
%pasaporte(Persona, flex(juegoPremium)).
%pasaporte(Persona, premium()).
pasaporte(marcos, basico(30)).
pasaporte(osvaldo, flex(montaniaRusa)).
pasaporte(nina, premium).

%Parques y atracciones:
%atraccion(Nombre, Parque, requisitos(EdadMinima, AlturaMinima)
atraccion(trenFantasma, parqueDeLaCosta, requisitos(12, 0)).
atraccion(montaniaRusa, parqueDeLaCosta, requisitos(0, 130)).
atraccion(maquinaTiquetera, parqueDeLaCosta, requisitos(0, 0)).
atraccion(toboganGiganteLaOlaAzul, parqueAcuatico, requisitos(0, 150)).
atraccion(rioLentoCorrienteSerpenteante, parqueAcuatico, requisitos(0, 0)).
atraccion(piscinaDeOlasMaremoto, parqueAcuatico, requisitos(5, 0)).

parque(parqueDeLaCosta).
parque(parqueAcuatico).
%Pasaporte:
%juego(Atraccion, Calidad(req1, req2,...)).
%juego(Atraccion, premium()).
%juego(Atraccion, comun(CostoEnCreditos)).
juego(maquinaTiquetera, comun(10)).
juego(trenFantasma, comun(20)).
juego(montaniaRusa, premium()).
juego(toboganGiganteLaOlaAzul, comun(10)).
juego(rioLentoCorrienteSerpenteante, comun(20)).
juego(piscinaDeOlasMaremoto, premium()).

%Requerimientos:
puedeSubir(Persona, Atraccion) :-
    atraccion(Atraccion, _, requisitos(EdadMinima, AlturaMinima)),
    persona(Persona, Edad, Altura),
    Edad >= EdadMinima,
    Altura >= AlturaMinima,
    tieneAcceso(Persona, Atraccion).

tieneAcceso(Persona, _) :-
    pasaporte(Persona, premium()).
tieneAcceso(Persona, Atraccion) :-
    pasaporte(Persona, flex(Atraccion)).
tieneAcceso(Persona, Atraccion) :-
    juego(Atraccion, comun(CreditosNecesarios)),
    pasaporte(Persona, basico(Creditos)),
    Creditos >= CreditosNecesarios.

esParaElle(Persona, Parque) :-
    persona(Persona),
    parque(Parque),
    forall(atraccion(Atraccion, Parque, _), puedeSubir(Persona, Atraccion)).

edadEntre(Persona, LimiteInferior, LimiteSuperior) :-
    edad(Persona, Edad),
    Edad >= LimiteInferior,
    Edad =< LimiteSuperior.

edad(Persona, Edad) :-
    persona(Persona, Edad, _).

grupoEtario(ninio, Persona) :-
    edad(Persona, Edad),
    Edad =< 11.
grupoEtario(adolescente, Persona) :-
    edadEntre(Persona, 12, 18).
grupoEtario(joven, Persona) :-
    edadEntre(Persona, 19, 26).
grupoEtario(adulto, Persona) :-
    edadEntre(Persona, 27, 59).
grupoEtario(viejo, Persona) :-
    edad(Persona, Edad),
    Edad >= 60.

malaIdea(GrupoEtario, Parque) :-
    grupoEtario(GrupoEtario, _),
    atracciones(Parque, Atracciones),
    forall(grupoEtario(GrupoEtario, Persona), not(puedeSubirAAlgunaAtraccion(Persona, Atracciones))).

puedeSubirAAlgunaAtraccion(Persona, Atracciones) :-
    member(Atraccion, Atracciones),
    puedeSubir(Persona, Atraccion).

atracciones(Parque, Atracciones) :-
    parque(Parque),
    findall(Atraccion, atraccion(Atraccion, Parque, _), Atracciones).

%Programas: los trataré como listas de atracciones
programa([toboganGiganteLaOlaAzul, piscinaDeOlasMaremoto, rioLentoCorrienteSerpenteante]).

programa(Programa) :-
    forall(member(Cosa, Programa), atraccion(Cosa)).

atraccion(Atraccion) :-
    atraccion(Atraccion, _, _).

%Requerimientos:
programaLogico(Programa) :-
    noRepiteAtracciones(Programa),
    sonTodasDelMismoParque(Programa).

sonTodasDelMismoParque(Programa) :-
    programa(Programa),
    parque(Parque),
    forall(member(Atraccion, Programa), atraccion(Atraccion, Parque, _)).

noRepiteAtracciones(Programa) :-
    programa(Programa),
    list_to_set(Programa, Programa).

hastaAca(Persona, ProgramaCompleto, ProgramaFinal) :-
    persona(Persona),
    programa(ProgramaCompleto),
    hastaQueNoPuedaSubir(Persona, ProgramaCompleto, ProgramaFinal).

hastaQueNoPuedaSubir(_, [], []).

hastaQueNoPuedaSubir(Persona, [Atraccion|RestoAtracciones], Atraccion|Atracciones):-
    puedeSubir(Persona, Atraccion), 
    hastaQueNoPuedaSubir(Persona, RestoAtracciones, Atracciones).

hastaQueNoPuedaSubir(Persona, [Atraccion|_], []):-
    not(puedeSubir(Persona, Atraccion)).