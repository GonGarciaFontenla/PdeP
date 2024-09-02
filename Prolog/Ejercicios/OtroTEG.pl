%enunciado: https://docs.google.com/document/d/1EZwhld9TuBsWUcIMZX5OFG05OKLCHsLSKOzU6kNUzkU/edit

paisContinente(americaDelSur, argentina).
paisContinente(americaDelSur, bolivia).
paisContinente(americaDelSur, brasil).
paisContinente(americaDelSur, chile).
paisContinente(americaDelSur, ecuador).
paisContinente(europa, alemania).
paisContinente(europa, espania).
paisContinente(europa, francia).
paisContinente(europa, inglaterra).
paisContinente(asia, aral).
paisContinente(asia, china).
paisContinente(asia, india).
paisContinente(asia, afganistan).
paisContinente(asia, nepal).

paisImportante(argentina).
paisImportante(alemania).

limitrofes(argentina, brasil).
limitrofes(bolivia, brasil).
limitrofes(bolivia, argentina).
limitrofes(argentina, chile).
limitrofes(espania, francia).
limitrofes(alemania, francia).
limitrofes(nepal, india).
limitrofes(china, india).
limitrofes(nepal, china).
limitrofes(afganistan, china).

ocupa(argentina, azul).
ocupa(bolivia, rojo).
ocupa(brasil, verde).
ocupa(chile, negro).
ocupa(ecuador, rojo).
ocupa(alemania, azul).
ocupa(espania, azul).
ocupa(francia, azul).
ocupa(inglaterra, azul).
ocupa(aral, verde).
ocupa(china, negro).
ocupa(india, verde).
ocupa(afganistan, verde).

continente(americaDelSur).
continente(europa).
continente(asia).

%Punto 1:
estEnContinente(Jugador, Continente) :-
    continente(Continente),
    ocupa(Pais, Jugador),
    estaEn(Continente, Pais).

%Punto 2:
ocupaContintente(Jugador, Continente) :-
    jugador(Jugador),
    continente(Continente),
    forall(estaEn(Continente, Pais), ocupa(Pais, Jugador)).

jugador(Jugador) :-
    ocupa(_, Jugador).

%punto3:
cubaLibre(Pais) :-
    pais(Pais),
    not(ocupa(Pais, _)).

pais(Pais) :-
    paisContinente(_, Pais).

%Punto4:
leFaltaMucho(Jugador, Continente) :-
    estaEnContinente(Jugador, Continente),
    noEstaEnPaisDelContinente(Jugador, Continente, Pais1),
    noEstaEnPaisDelContinente(Jugador, Continente, Pais2),
    Pais1 \= Pais2.

noEstaEnPaisDelContinente(Jugador, Continente, Pais) :-
    paisContinente(Continente, Pais),
    jugador(Jugador),
    not(ocupa(Pais, Jugador)).

%Punto 5:
sonLimitrofes(Pais, OtroPais) :-
    limitrofes(OtroPais, Pais).

sonLimitrofes(Pais, OtroPais) :-
    limitrofes(Pais, OtroPais).

%Punto 6:
tipoImportante(Jugador) :-
    jugador(Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador)).

%Punto 7:
estaEnElHorno(Pais) :-
    ocupa(Pais, Jugador),
    jugador(OtroJugador),
    Jugador \= OtroJugador,
    forall(sonLimitrofes(Pais, OtroPais), ocupa(OtroPais, Jugador)).

%Punto 8:
esCompartido(Continente) :-
    estEnContinente(Jugador, Continente),
    estEnContinente(OtroJugador, Continente),
    Jugador \= OtroJugador.