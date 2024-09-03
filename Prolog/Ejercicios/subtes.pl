%enunciado: https://docs.google.com/document/d/1wcnGLFbtL9wwgJpwD9-UBIdRdDzaHbYa3TErdL7M9Wo/edit#heading=h.gp6pcj79dovz

linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,pueyrredonB,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).
linea(d,[catedral,nueveJulio,medicina,pueyrredonD,plazaItalia,carranza,congresoTucuman]).
linea(e,[bolivar,independenciaE,pichincha,jujuy,boedo,varela,virreyes]).
linea(h,[lasHeras,santaFe,corrientes,once,venezuela,humberto1ro,inclan,caseros]).

combinacion([lima, avMayo]).
combinacion([once, miserere]).
combinacion([pellegrini, diagNorte, nueveJulio]).
combinacion([independenciaC, independenciaE]).
combinacion([jujuy, humberto1ro]).
combinacion([santaFe, pueyrredonD]).
combinacion([corrientes, pueyrredonB]).

%Punto 1:
estaEn(Linea, Estacion) :-
    linea(Linea, Estaciones),
    member(Estacion, Estaciones).

%Punto 2:
distancia(Estacion1, Estacion2, Distancia) :-
    mismaLinea(Estacion1, Estacion2),
    posicion(Posicion1, Estacion1),
    posicion(Posicion2, Estacion2),
    DistanciaPrima is Posicion1 - Posicion2,
    abs(DistanciaPrima, Distancia).

mismaLinea(Estacion1, Estacion2) :-
    estaEn(Linea, Estacion1),
    estaEn(Linea, Estacion2).

posicion(Estacion, Posicion) :-
    estaEn(Linea, Estacion),
    linea(Linea, Estaciones),
    nth(Posicion, Estaciones, Estacion).

%Punto 3:
mismaAltura(Estacion1, Estacion2) :-
    posicion(Altura, Estacion1),
    posicion(Altura, Estacion2).

%Punto 4:
granCombinacion(Combinacion) :-
    combinacion(Combinacion),
    length(Combinacion, Cantidad),
    Cantidad > 2.

%Punto 5:
cuantasCombinan(Linea, Cantidad) :-
    linea(Linea, _),
    findall(Estacion, combinaEnUnaLinea(Estacion, Linea), EstacionesQueCombinan),
    lenght(EstacionesQueCombinan, Cantidad).

combina(Estacion, Linea) :-
    estaEn(Linea, Estacion),
    combinacion(Combinacion),
    member(Estacion, Combinacion).

%Punto 6:
lineaMasLarga(Linea) :-
    cantidadEstaciones(Linea, CantidadMaxima),
    forall(linea(_, EstacionesAjenas), hayMenosEstacionesQue(CantidadMaxima, EstacionesAjenas)).

hayMenosEstacionesQue(Cantidad, Estaciones) :-
    length(Estaciones, OtraCantidad),
    Cantidad >= OtraCantidad.

cantidadEstaciones(Linea, Cantidad) :-
    linea(Linea, Estaciones),
    length(Estaciones, Cantidad).

%Punto 7:
viajeFacil(Salida, Destino) :-
    mismaLinea(Salida, Destino).

viajeFacil(Salida, Destino) :-
    combinaEn(Salida, EstacionQueCombina1),
    combinaEn(Destino, EstacionQueCombina2),
    formaParteDeLaMismaCombinacion(EstacionQueCombina1, EstacionQueCombina2).

combinaEn(Estacion, EstacionQueCombina) :-
    estaEn(Linea, Estacion),
    linea(Linea, Estaciones),
    memeber(EstacionQueCombina, Estaciones).

formaParteDeLaMismaCombinacion(Combina1, Combina2) :-
    combinacion(Combinacion),
    member(Combina1, Combinacion),
    member(Combina2, Combinacion).