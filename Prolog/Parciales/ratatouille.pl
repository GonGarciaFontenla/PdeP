%rata(nombre, domicilio). 
rata(remy, gusteaus). 
rata(emile, chezMilleBar).
rata(django, pizzeriaJeSuis).

%humano(nombre, platoCocinan, experienciaCadaPlato). 
humano(linguini, ratatouille, 3). 
humano(linguini, sopa, 5). 
humano(colette, salmonAsado, 9). 
humano(horst, ensaladaRusa, 8). 

%trabaja(Quien, Donde). 
trabaja(linguini, gusteaus). 
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDes2Moulins).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).

critico(antonEgo). 
critico(cormillot). 
critico(martiniano). 
critico(gordonRamsey).  

%Saber si un plato está en el menú de un restaurante, que es cuando alguno de los empleados lo sabe cocinar.
estaEnElMenu(Restaurante, Plato):-
    trabaja(Empleado, Restaurante), 
    humano(Empleado, Plato, _).

%Saber quién cocina bien un determinado plato, que es verdadero para una persona si su experiencia preparando ese plato es mayor a 7, 
%ó si tiene un tutor que cocina bien el plato. Nos contaron que Linguini tiene como tutor a toda rata que viva en el lugar donde trabaja, 
%además que Amelie es la tutora de Skinner.
%También se sabe que remy cocina bien cualquier plato que exista, y el resto de las ratas no cocina bien nada.

cocinaBienPlato(Chef, Plato):-
    humano(Chef, Plato, Experiencia),
    Experiencia > 7. 

cocinaBienPlato(Chef, Plato):-
    tutorChef(Chef, Tutor), 
    cocinaBienPlato(Tutor, Plato).

cocinaBienPlato(remy, Plato):-
    humano(_, Plato, _).

tutorChef(linguini, Tutor):- trabaja(linguini, Restaurante), rata(Tutor, Restaurante). 
tutorChef(skinner, amelie).

%Saber si alguien es chef de un restó. Los chefs son, de los que trabajan en el restó, aquellos que cocinan bien 
%todos los platos del menú ó entre todos los platos que sabe cocinar suma una experiencia de al menos 20.
chef(Cocinero, Restaurante):-
    trabaja(Cocinero, Restaurante), 
    forall(estaEnElMenu(Restaurante, Plato), cocinaBienPlato(Cocinero, Plato)).

chef(Cocinero, Restaurante):- 
    trabaja(Cocinero, Restaurante), 
    cocineroExperimentado(Cocinero). 

cocineroExperimentado(Cocinero):-
    findall(Experiencia, humano(Cocinero, _, Experiencia), ListaExp), 
    sum_list(ListaExp, CantExp), 
    CantExp >= 20. 
    
%Deducir cuál es la persona encargada de cocinar un plato en un restaurante, que es quien más experiencia tiene preparándolo en ese lugar.
encargada(Cocinero, Plato, Restaurante):-
    humano(Cocinero, Plato, Experiencia),
    trabaja(Cocinero, Restaurante),
    forall((humano(OtroCocinero, Plato, OtraExperiencia), trabajaMismoResto(Cocinero, OtroCocinero)), Experiencia >= OtraExperiencia). 

trabajaMismoResto(C1, C2):- 
    trabaja(C1, R), 
    trabaja(C2, R),
    C1 \= C2.

%Si un plato es saludable (si tiene menos de 75 calorías).
%En las entradas, cada ingrediente suma 15 calorías.
%Los platos principales suman 5 calorías por cada minuto de cocción. Las guarniciones agregan a la cuenta total: las papas fritas 50 y el puré 20, mientras que la ensalada no aporta calorías.
%De los postres ya conocemos su cantidad de calorías.
esSaludable(Plato):-
    plato(Plato, Categoria), 
    platoLight(Categoria).

platoLight(Plato):-
    calorias(Plato, Calorias), 
    Calorias < 75. 

calorias(entrada(Ingredientes), Calorias):-
    length(Ingredientes, Cant), 
    Calorias is Cant * 15. 

calorias(principal(Guarnicion, Minutos), Calorias):-
    caloriasGuarnicion(Guarnicion, Cant), 
    Calorias is Minutos * 5 + Cant. 

calorias(postre(Calorias), Calorias).

caloriasGuarnicion(pure, 20).
caloriasGuarnicion(papasFritas, 50). 
caloriasGuarnicion(ensalada, 0). 

%Un restaurante recibe mayor reputación si un crítico le escribe una reseña positiva. Queremos saber si algún crítico le hizo una reseña positiva a algún restaurante.
reseniaPositiva(Resto, Critico):-
    trabaja(_, Resto), 
    critico(Critico), 
    not(rata(_, Resto)),
    cumpleCriterio(Resto, Critico). 

cumpleCriterio(Resto, antonEgo):- 
    forall(trabaja(Cocinero, Resto), cocinaBienPlato(Cocinero, ratatouille)).

cumpleCriterio(Resto, cormillot):-
    forall(estaEnElMenu(Resto, Plato), esSaludable(Plato)). 

cumpleCriterio(Resto, martiniano):-
    trabaja(Cocinero, Resto), 
    not((trabaja(Cocinero2, Resto), 
    Cocinero \= Cocinero2)).