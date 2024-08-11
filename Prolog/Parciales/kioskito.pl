%----------PUNTO 1----------%

%dodain atiende lunes, miércoles y viernes de 9 a 15.
atiende(dodain, lunes, 9, 15). 
atiende(dodain, miercoles, 9, 15). 
atiende(dodain, viernes, 9, 15). 

%lucas atiende los martes de 10 a 20
atiende(lucas, martes, 10, 20).

%juanC atiende los sábados y domingos de 18 a 22.
atiende(juanC, sabados, 18, 22). 
atiende(juanC, domingos, 18, 22). 

%juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
atiende(juanFdS, jueves, 12, 20). 
atiende(juanFdS, viernes, 12, 20). 

%leoC atiende los lunes y los miércoles de 14 a 18.
atiende(leoC, lunes, 14, 18). 
atiende(leoC, miercoles, 14, 18). 

%martu atiende los miércoles de 23 a 24.
atiende(martu, miercoles, 23, 24). 

%vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dia, HsInicio, HsFinal) :-
    atiende(dodain, Dia, HsInicio, HsFinal).

atiende(vale, Dia, HsInicio, HsFinal) :-
    atiende(juanC, Dia, HsInicio, HsFinal).

%nadie hace el mismo horario que leoC
    %Por el principio de universo cerrado, no hace falta agregar aquello que no tiene sentido agregar.

%maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
    %Por el principio de universo cerrado, consideramos como falso a lo desconocido (que piense tranquila). 

%----------PUNTO 2----------%
%Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko. 
quienAtiende(Persona, Dia, Horario):-
    atiende(Persona, Dia, HsInicial, HsFinal), 
    between(HsInicial, HsFinal, Horario).

%----------PUNTO 3----------%
%Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola.
foreverAlone(Persona, Dia, Horario):-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(Persona2, Dia, Horario), Persona \= Persona2)).

%----------PUNTO 4----------%
atenPosible(Dia, Personas):-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), EmpleadosPosibles), 
    realizarCombinaciones(EmpleadosPosibles, Personas). 

realizarCombinaciones([], []).

realizarCombinaciones([Persona|EmpleadosPosibles], [Persona|Personas]):-
    realizarCombinaciones(EmpleadosPosibles, Personas).

realizarCombinaciones([_|EmpleadosPosibles], Personas):-
    realizarCombinaciones(EmpleadosPosibles, Personas).

% Qué conceptos en conjunto resuelven este requerimiento
    % - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
    % - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles

%----------PUNTO 5----------%
%dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50}
ventas(dodain, fecha(10, 8), [golosinas(1200), cigarrillos([jockey]), golosinas(10)]).

%dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
ventas(dodian, fecha(12, 8), [bebidas(true, 8), bebidas(false, 1), golosinas(10)]). 

%martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
ventas(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado,parisiennes])]).

%lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
ventas(lucas, fecha(11, 8), [golosinas(600)]). 

%lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
ventas(lucas, fecha(18,8), [bebidas(false, 2), cigarrillos([derby])]).

vendedoraSuertuda(Persona):-
    vendedora(Persona), 
    forall(ventas(Persona, _ , [Venta, _]), ventaImportante(Venta)).

vendedora(Persona) :-
    ventas(Persona, _, _). 
    
%Una venta es importante:
    %en el caso de las golosinas, si supera los $ 100.
    %en el caso de los cigarrillos, si tiene más de dos marcas.
    %en el caso de las bebidas, si son alcohólicas o son más de 5.}

ventaImportante(golosinas(Precio)):- Precio > 100. 
ventaImportante(cigarrillos(Marcas)):- length(Marcas, Cantidad), Cantidad > 2.
ventaImportante(bebidas(true, _)).
ventaImportante(bebidas(_, Cantidad)) :- Cantidad > 5. 

    

