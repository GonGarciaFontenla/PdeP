% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927). 
cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

%Saber si una canción es un hit, lo cual ocurre si aparece en el ranking top 3 de todos los meses.
hit(Cancion):- 
    cancion(Cancion, _, _),
    forall(rankingTop3(Mes, _, _), estaEnTop(Mes, Cancion)). 

estaEnTop(Mes, Cancion):- 
    rankingTop3(Mes, _, Cancion). 

%Saber si una canción no es reconocida por los críticos, lo cual ocurre si tiene muchas reproducciones y 
%nunca estuvo en el ranking. Una canción tiene muchas reproducciones si tiene más de 7000000 reproducciones.
noReconocida(Cancion):- 
    cancion(Cancion, _, _), 
    muchasReproducciones(Cancion), 
    nuncaEnRanking(Cancion). 

muchasReproducciones(Cancion):-
    cancion(Cancion, _, Reproducciones), 
    Reproducciones > 7000000. 

nuncaEnRanking(Cancion):- 
    not(rankingTop3(_, _, Cancion)).

%Saber si dos compositores son colaboradores, lo cual ocurre si compusieron alguna canción juntos.
colaboradores(Compositor1, Compositor2):- 
    ambosCompusieronCancion(Compositor1, Compositor2). 

ambosCompusieronCancion(C1, C2):- 
    cancion(_, Compositores, _), 
    member(C1, Compositores), 
    member(C2, Compositores), 
    C1 \= C2. 

%Los conductores, de los cuales nos interesa sus años de experiencia.
%Los periodistas, de los cuales nos interesa sus años de experiencia y su título, el cual puede ser licenciatura o posgrado. 
%Los reporteros, de los cuales nos interesa sus años de experiencia y la cantidad de notas que hicieron a lo largo de su carrera.
trabajador(tulio, conductor(5)). 
trabajador(bodoque, periodista(2, licenciatura)). 
trabajador(bodoque, reportero(5, 300)). 
trabajador(marioHugo, periodista(10, posgrado)). 
trabajador(juanin, conductor(0)). 
%trabajador(nombre camarografo(anios, horasSemanales, tipoCamara)).
trabajador(gonza, camarografo(5, 30, camaraPro)).
trabajador(santi, camarografo(1, 20, camaraMala)). 
 
%Conocer el sueldo total de una persona, el cual está dado por la suma de los sueldos de cada uno de sus trabajos
sueldoTotal(Trabajador, Sueldo):-
    trabajador(Trabajador, _), 
    findall(Salary, (trabajador(Trabajador, Trabajo), sueldo(Trabajo, Salary)), ListaSueldos), 
    sum_list(ListaSueldos, Sueldo). 

sueldo(conductor(Anios), S):- S is Anios * 10000.

sueldo(reportero(Anios, Notas), S):- S is Anios * 10000 + Notas * 100. 

sueldo(periodista(Anios, Titulo), S):- 
    aumentoSegunTitulo(Titulo, Aumento), 
    S is Anios * 5000 * (1 + Aumento/100). 

sueldo(camarografo(Anios, HorasSemanales, Camara), S):-
    bonusPorCamara(Camara, Bonus), 
    S is Anios * 10000 + HorasSemanales * 100 + Bonus. 

aumentoSegunTitulo(licenciatura, 20). 
aumentoSegunTitulo(posgrado, 35). 

bonusPorCamara(camaraPro, 5000). 
bonusPorCamara(camaraMala, 2000). 

%Agregar un nuevo trabajador que tenga otro tipo de trabajo nuevo distinto a los anteriores. Agregar una forma 
%de calcular el sueldo para el nuevo trabajo agregado ¿Qué concepto de la materia se puede relacionar a esto?
    %Lo relacionaría con Polimorfismo, ya que la regla sueldo se puede adaptar para calcular el sueldo de los diferentes 
    %tipos de trabajadores. En otras palabras, la regla sueldo tiene la capacidad de manejar diferentes casos o tipos de datos.

