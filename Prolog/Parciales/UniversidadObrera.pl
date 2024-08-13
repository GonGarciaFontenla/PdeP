% Ejemplos de personas que estudian
%estudia(Nombre,Carrera,Universidad).
estudia(ana, ingenieriaSistemas, utn).
estudia(paula, ingenieriaMecanica, utn).
estudia(gonza, ingenieriaSistemas, utn).
estudia(luis, medicina, uba).
estudia(sofia, derecho, uba).
estudia(diego, arquitectura, uba).
estudia(jorge, ingenieriaMecanica, uca).
estudia(carla, biologia, sanAndres).
estudia(fernando, cienciasPoliticas, uca).

% Ejemplos de personas que trabajan
%trabaja(Nombre,Trabajo,CantHoras). 
trabaja(gonza, empleoPrivado(microsoft, tecnologico), 40).
trabaja(paula, empleoPrivado(michellin, automotriz), 35).
trabaja(ana, empleoPrivado(ibm, tecnologico), 45).
trabaja(sofia, empleoPublico(defensoria, estado, legal), 30).
trabaja(luis, empleoPublico(hospitalDubarri, municipal, salud), 50).
trabaja(diego, empleoPrivado(constructoraPepe, construccion), 30).
trabaja(fernando, planSocial(algo), 20). 
%emprendedor(emprendimiento, inversores, rubro).
trabaja(jorge, emprendedor(tuerquitasJorge, [michellin, ferreteriaPepe, metalurgicaPepe], automotriz)). 

organizacion(algo, legal). 

%habilitacionProfesional(Carrera,ListaDeRubros).
habilitacionProfesional(ingenieriaSistemas, [tecnologico]). 
habilitacionProfesional(ingenieriaMecanica, [automotriz, aeroespacial]). 
habilitacionProfesional(medicina, [salud]). 
habilitacionProfesional(derecho, [legal]). 
habilitacionProfesional(arquitectura, [construccion]). 
habilitacionProfesional(biologia, [salud, investigacion]). %Medio raro salud, pero estoy poco creativo.
habilitacionProfesional(cienciasPoliticas, [legal, politico]). 

%Las universidades a las que puede calificarse como obreras, considerando que todos los estudiantes de esa universidad trabajan.
universidadObrera(Universidad):-    
    estudia(_, _, Universidad), 
    forall(estudia(Estudiante, _, Universidad), trabaja(Estudiante, _, _)). 


%Si una carrera es exigente en una universidad, es decir, que ningún estudiante de dicha carrera en esa universidad puede trabajar o estudiar otra carrera a la vez.
%Habria que pensar mejor nombre para los predicados. 
carreraExigente2(Carrera, Universidad):- 
    estudia(_, Carrera, Universidad),
    nadieOtraCarreraTrabaja(Carrera, Universidad). 

nadieOtraCarreraTrabaja(Carrera, Universidad):- 
    forall(estudia(Estudiante, Carrera, Universidad), not(anotadoOtraCarreraYTrabaja(Estudiante))).

anotadoOtraCarreraYTrabaja(Estudiante):-
    estudia(Estudiante, Carrera1, _), 
    estudia(Estudiante, Carrera2, _), 
    Carrera1 \= Carrera2, 
    trabaja(Estudiante, _, _). 

%Encontrar la universidad con mayor porcentaje de estudiantes trabajadores.
universidadLaburadora(Universidad):- 
    estudia(_,_,Universidad), 
    forall(estudia(_ ,_, OtraUniversidad), menorCantTrabajadores(Universidad, OtraUniversidad)). 

menorCantTrabajadores(Universidad, OtraUniversidad):- 
    cantTrabajadores(Universidad, Trabajadores), 
    cantTrabajadores(OtraUniversidad, Trabajadores2), 
    Trabajadores2 =< Trabajadores. 

cantTrabajadores(Universidad, Trabajadores):-
    findall(Trabajador, (estudia(Trabajador, _, Universidad), trabaja(Trabajador, _, _)), ListaTrabajadores), 
    length(ListaTrabajadores, Trabajadores). 
    
%Las personas que trabajan, pero nunca en algo vinculado con una carrera que estudien.
%No hay ninguno --> Por eso da false la consigna. 
trabajadorDesvinculados(Trabajador):-
    trabaja(Trabajador, Trabajo, _), 
    estudia(Trabajador, Carrera, _),
    rubroTrabajador(Trabajo, Rubro), 
    not(rubroPerteneceCarrera(Carrera, Rubro)). 

rubroPerteneceCarrera(Carrera, Rubro):-
    habilitacionProfesional(Carrera, Rubros), 
    member(Rubro, Rubros).

rubroTrabajador(empleoPrivado(_, Rubro), Rubro). 
rubroTrabajador(empleoPublico(_, _, Rubro), Rubro). 
rubroTrabajador(planSocial(Organizacion), Rubro) :-
    organizacion(Organizacion, Rubro).
%Obtener rubro de emprendedores. 
rubroTrabajador(emprendedor(_, _, Rubro), Rubro). 

%Las carreras demandadas, que son aquellas en las que todos los estudiantes de esa carrera, en cualquier universidad, trabajan en algo vinculado con dicha carrera.
carreraDemandada(Carrera):-
    estudia(_, Carrera, _), 
    forall(estudia(Estudiante, Carrera, _), trabajaEnRubroVinculado(Estudiante)).

trabajaEnRubroVinculado(Estudiante):- 
    trabaja(Estudiante, _, _), 
    not(trabajadorDesvinculados(Estudiante)).

%Agregarla de una manera original, en la que se necesite recurrir a otros predicados para obtener el rubro y que todo siga funcionando. Justificar conceptualmente.
    %El concepto que nos permite incluir nuevos rubros sin hacer modificaciones en los predicados es el polimorfismo. 
    %Gracias al polimorfimos, los predicados tienen la capacidad de manejar diferentes tipos de datos.