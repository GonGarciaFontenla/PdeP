%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais). 
resultado(paises_bajos, 3, estados_unidos, 1). % Paises bajos 3 - 1 Estados unidos
resultado(australia, 1, argentina, 2). % Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).


% Pronósticos de los jugadores
pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1, 0)).

%jugaron/3 --> Relaciona dos paises que hayan jugado un partido y diferencia de goles entre ambos. 
jugaron(EquipoL, EquipoV, Diferencia):-
    resultadoSimetrico(EquipoL, GolesL, EquipoV, GolesV), 
    Diferencia is GolesL - GolesV.

resultadoSimetrico(E1,G1, E2,G2):- resultado(E1, G1, E2, G2). 
resultadoSimetrico(E1, G1, E2, G2):- resultado(E2, G2, E1, G1).

%gano/2 --> Un pais le gano al otro si ambos equipos jugaron y uno le metio mas goles que el otro. 
gano(EquipoL, EquipoV):-
    resultadoSimetrico(EquipoL, GolesL, EquipoV, GolesV),
    masCantidadGoles(GolesL, GolesV). 

masCantidadGoles(N1, N2):- 
    Diferencia is N1 - N2, 
    Diferencia > 0.

%PuntosPronostico/2: 
    %Pego ganador/empate y goles --> 200 puntos. 
    %Pego ganador/empate y no goles --> 100 puntos. 
    %Erro todo --> 0 puntos. 
puntosPronostico(Pronostico, Puntos):-
    partidoJugado(Pronostico), 
    calcularPuntos(Pronostico, Puntos). 

calcularPuntos(Pronostico, 200):- 
    pegoVictoriaOempate(Pronostico), 
    acertoGoles(Pronostico). 

calcularPuntos(Pronostico, 100):-
    pegoVictoriaOempate(Pronostico), 
    not(acertoGoles(Pronostico)).

calcularPuntos(Pronostico, 0):-
    not(pegoVictoriaOempate(Pronostico)), 
    not(acertoGoles(Pronostico)).

pegoVictoriaOempate(gano(PaisG, PaisP, _, _)):- gano(PaisG, PaisP). 
pegoVictoriaOempate(empate(PaisL, PaisV, _)):- resultadoSimetrico(PaisL, _, PaisV, _). %Como es empate si invierto los resultados, no hay drama. 

acertoGoles(gano(PaisG, PaisP, G1, G2)):- 
    resultadoSimetrico(PaisG, G1, PaisP, G2). 

acertoGoles(empate(PaisG, PaisP, Goles)):- resultadoSimetrico(PaisG, Goles, PaisP, Goles). 


%invicto/1 --> Un jugador esta invicto si saco al menos 100 puntos en cada pronostico que hizo. 
invicto(Jugador):-
    pronostico(Jugador, _),
    forall((pronostico(Jugador, Pronostico), partidoJugado(Pronostico)), masDeCienPuntos(Pronostico)).

masDeCienPuntos(Pronostico):-
    puntosPronostico(Pronostico, Puntos), 
    Puntos >= 100.

partidoJugado(gano(Pais1, Pais2, _, _)):-
    resultadoSimetrico(Pais1, _, Pais2, _). 

partidoJugado(empataron(Pais1, Pais2, _)):-
    resultadoSimetrico(Pais1,_,Pais2, _). 

%puntaje/2 --> Relacionar a un jugador con el total de puntos que hizo por todos sus pronosticos. 
puntaje(Persona, PuntajeTotal):-
    pronostico(Persona, _),
    findall(Puntaje, (pronostico(Persona, Pronostico), puntosPronostico(Pronostico, Puntaje)), ListaPuntajes), 
    sum_list(ListaPuntajes, PuntajeTotal).

%favorito/1 --> Una seleccion es favorita, si para todo pronostico que se hizo sobre ese pais, se lo pone como ganador. 
%           --> Una seleeccion es favorito, si gano todos los partidos por goleada. 

favorito(Pais):-
    estaEnElPronostico(Pais,_), %Para inversibilidad. 
    forall(estaEnElPronostico(Pais, Pronostico), seLoDaComoGanador(Pais, Pronostico)). 

favorito(Pais):-
    resultadoSimetrico(Pais, _, _, _),
    forall(jugaron(Pais, _, Diferencia), Diferencia >= 3). 

estaEnElPronostico(Pais, gano(Pais, OtroPais, Goles1, Goles2)) :- pronostico(_, gano(Pais, OtroPais, Goles1, Goles2)).
estaEnElPronostico(Pais, gano(OtroPais, Pais, Goles1, Goles2)) :- pronostico(_, gano(OtroPais, Pais, Goles1, Goles2)).
estaEnElPronostico(Pais, empataron(Pais, OtroPais, Goles)) :- pronostico(_, empataron(Pais, OtroPais, Goles)).
estaEnElPronostico(Pais, empataron(OtroPais, Pais, Goles)) :- pronostico(_, empataron(OtroPais, Pais, Goles)).

seLoDaComoGanador(Pais, gano(Pais, _, _, _)). 