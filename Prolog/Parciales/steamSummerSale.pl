%enunciado: https://docs.google.com/document/d/1XCwQt3f93h_uFzFlTFwf1YFAFglmQg84FyHIM5_Vp0Y/edit

%juego(Nombre, Precio, genero(Car1,Car2,Car3...)).
%juego(Nombre, Precio, accion()).
juego(callOfDuty, 15000, accion()).
juego(darkSouls3, 23000, accion()).
juego(blackMythWukong, 70000, accion()).
juego(counterStrike, 0, accion()).
%juego(Nombre, Precio, rol(CantidadDeJugadoresActivos)).
juego(baldursGate3, 40000, rol(2000000)).
juego(starWarsKOTR, 5000, rol(500000)).
juego(dragonAge, 70000, rol(20000)).
juego(minecraft, 30000, rol(500000)).
%juego(Nombre, Precio, puzzle(CantidadDeNiveles, Dificultad)).
juego(babaIsYou, 10000, puzzle(25, media)).
juego(portal, 3000, puzzle(32, facil)).
juego(portal2, 3000, puzzle(43, media)).
juego(monkeyIsland, 20000, puzzle(30, dificil)).

%predicado para extraer el nomnbre y/o unificar:
juego(Juego) :-
    juego(Juego, _, _).

%predicado para extraer el precio original:
precioOriginal(Juego, Precio) :-
    juego(Juego, Precio, _).

%predicado para extraer el genero:
genero(Juego, accion) :-
    juego(Juego, _, accion()).
genero(Juego, rol) :-
    juego(Juego, _, rol(_)).
genero(Juego, puzzle) :-
    juego(Juego, _, puzzle(_, _)).

%oferta(Juego, Descuento).
%por principio de universo cerrado, quienes no formen parte de este predicado no estan en oferta
oferta(callOfDuty, 33).
oferta(darkSouls3, 85).
oferta(baldursGate3, 35).
oferta(starWarsKOTR, 75).
oferta(minecraft, 66).
oferta(babaIsYou, 32).
oferta(portal, 55).
oferta(portal2, 55).

estaEnOferta(Juego) :-
    oferta(Juego, _).

cuantoSale(Juego, Precio) :-
    juego(Juego),
    not(estaEnOferta(Juego)),
    precioOriginal(Juego, Precio).

cuantoSale(Juego, Precio) :-
    estaEnOferta(Juego),
    oferta(Juego, Porcentaje),
    precioOriginal(Juego, PrecioOriginal),
    Precio is PrecioOriginal - (PrecioOriginal * (Porcentaje/100)).

tieneUnBuenDescuento(Juego) :-
    estaEnOferta(Juego),
    oferta(Juego, Descuento),
    Descuento >= 50.

popular(counterStrike).
popular(minecraft).
popular(Juego) :-
    genero(Juego, Genero),
    popularidadSegunGenero(Juego, Genero).

popularidadSegunGenero(_, accion).
popularidadSegunGenero(Juego, rol) :-
    juego(Juego, _, rol(CantidadDeJugadoresActivos)),
    CantidadDeJugadoresActivos > 1000000.
popularidadSegunGenero(Juego, puzzle) :-
    juego(Juego, _, puzzle(25, _)).
popularidadSegunGenero(Juego, puzzle) :-
    juego(Juego, _, puzzle(_, facil)).

%usuarios
%usuario(Nombre, JuegosPropios, JuegosAAdquirir(adquisicionPropia(juego), regalo(juego, paraQuien))).
usuario(berty, [portal, portal2, babaIsYou], [adquisicionPropia(darkSouls3), regalo(starWarsKOTR, santiago), regalo(portal, santiago), adquisicionPropia(starWarsKOTR)]).
usuario(santiago, [minecraft], [regalo(minecraft, berty), adquisicionPropia(blackMythWukong), adquisicionPropia(portal2)]).

adictoALosDescuentos(Usuario) :-
    usuario(Usuario, _, JuegosAAdquirir),
    forall(member(Adquisicion, JuegosAAdquirir), buenaAdquisicion(Adquisicion)).

buenaAdquisicion(adquisicionPropia(Juego)) :-
    tieneUnBuenDescuento(Juego).
buenaAdquisicion(regalo(Juego, _)) :-
    tieneUnBuenDescuento(Juego).

fanatico(Usuario, Genero) :-
    usuario(Usuario, JuegosQueTiene, _),
    genero(_, Genero),
    member(Juego1, JuegosQueTiene),
    member(Juego2, JuegosQueTiene),
    Juego1 \= Juego2,
    genero(Juego1, Genero),
    genero(Juego2, Genero).

monotematico(Usuario, Genero) :-
    usuario(Usuario, JuegosQueTiene, _),
    genero(_, Genero),
    forall(member(Juego, JuegosQueTiene), genero(Juego, Genero)).

buenosAmigos(Usuario, OtroUsuario) :-
    leRegalaJuegosPopularesA(Usuario, OtroUsuario),
    leRegalaJuegosPopularesA(OtroUsuario, Usuario).

leRegalaJuegosPopularesA(Usuario, OtroUsuario) :-
    usuario(Usuario, _, JuegosAAdquirir),
    member(Regalo, JuegosAAdquirir),
    esRegaloElJuegoPopularPara(Regalo, OtroUsuario).

esRegaloElJuegoPopularPara(regalo(Juego, OtroUsuario), OtroUsuario) :-
    popular(Juego).

cuantoGastara(Usuario, Dinero, Filtro) :-
    usuario(Usuario, _, _),
    findall(Costo, costoDeAdquisicion(Usuario, Costo, Filtro), Costos),
    sumlist(Costos, Dinero).

costoDeAdquisicion(Usuario, Costo, Filtro) :-
    usuario(Usuario, _, Adquisiciones),
    tipoDeAdquisicion(Filtro),
    member(Adquisicion, Adquisiciones),
    precioSegunAdquisicion(Adquisicion, Costo, Filtro).

precioSegunAdquisicion(adquisicionPropia(Juego), Costo, propia) :-
    cuantoSale(Juego, Costo).
precioSegunAdquisicion(adquisicionPropia(Juego), Costo, ambas) :-
    cuantoSale(Juego, Costo).
precioSegunAdquisicion(regalo(Juego, _), Costo, regalo) :-
    cuantoSale(Juego, Costo).
precioSegunAdquisicion(regalo(Juego, _), Costo, ambas) :-
    cuantoSale(Juego, Costo).

tipoDeAdquisicion(ambas).
tipoDeAdquisicion(propia).
tipoDeAdquisicion(regalo).