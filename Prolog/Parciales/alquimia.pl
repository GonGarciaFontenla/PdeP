elemento(ana, agua). 
elemento(ana, vapor). 
elemento(ana, tierra).
elemento(ana, hierro). 
elemento(beto, agua). 
elemento(beto, vapor). 
elemento(beto, tierra).
elemento(beto, hierro). 
elemento(cata, fuego).
elemento(cata, tierra). 
elemento(cata, agua). 
elemento(cata, aire). 

receta(pasto, [agua, tierra]). 
receta(hierro, [fuego, agua, tierra]). 
receta(huesos, [pasto, agua]). 
receta(presion, [hierro, vapor]).
receta(vapor, [agua, fuego]). 
receta(playStation, [silicio, hierro, plastico]). 
receta(silicio, [tierra]).
receta(plastico, [huesos, presion]). 

herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

%Saber si un jugador tieneIngredientesPara construir un elemento, que es cuando tiene ahora en su inventario todo lo que hace falta.
tieneIngredientesPara(Jugador, Elemento):- 
    elemento(Jugador,_), 
    receta(Elemento, _), 
    forall(necesita(Elemento, Ingrediente), elemento(Jugador, Ingrediente)). 

necesita(Elemento, Ingrediente):-
    receta(Elemento, Ingredientes), 
    member(Ingrediente, Ingredientes). 

%Saber si un elemento estaVivo. Se sabe que el agua, el fuego y todo lo que fue construido a partir de alguno de ellos, están vivos. Debe funcionar para cualquier nivel.
estaVivo(agua). 
estaVivo(fuego). 
estaVivo(Elemento):-
    necesita(Elemento, Ingrediente), 
    estaVivo(Ingrediente). 

%Conocer las personas que puedeConstruir un elemento, para lo que se necesita tener los ingredientes ahora en el inventario y 
%además contar con una o más herramientas que sirvan para construirlo.
puedeConstruir(Jugador, Elemento):-
    tieneIngredientesPara(Jugador, Elemento), 
    tieneHerramienta(Jugador, Elemento).

tieneHerramienta(Jugador, Elemento):-
    estaVivo(Elemento), 
    herramienta(Jugador, libro(vida)). 

tieneHerramienta(Jugador, Elemento):-
    not(estaVivo(Elemento)), 
    herramienta(Jugador, libro(inerte)). 

tieneHerramienta(Jugador, Elemento):-
    herramienta(Jugador, Herramienta),
    cantidadIngredientes(Elemento, CantElementos), 
    herramientoSoporta(Herramienta, CantSoporta), 
    CantElementos =< CantSoporta. 

cantidadIngredientes(Elemento, CantElementos):-
    receta(Elemento, Ingredientes), 
    length(Ingredientes, CantElementos). 

herramientoSoporta(cuchara(Cm), CantSoporta):- CantSoporta is (Cm/10). 
herramientoSoporta(circulo(Diametro, Niveles), CantSoporta):- CantSoporta is (Diametro/100 * Niveles).

%Saber si alguien es todopoderoso, que es cuando tiene todos los elementos primitivos (los que no pueden construirse a partir de nada) }
%y además cuenta con herramientas que sirven para construir cada elemento que no tenga.
todoPoderoso(Jugador):-
    elemento(Jugador, _),
    tieneElementosPrimitivos(Jugador), 
    forall((receta(Elemento, _), not(elemento(Jugador, Elemento))), tieneHerramienta(Jugador, Elemento)). 

tieneElementosPrimitivos(Jugador):-
    forall(elementoPrimitivo(Elemento), elemento(Jugador, Elemento)). 

elementoPrimitivo(Elemento):-
    elementos(Elemento),
    not(receta(Elemento, _)). 

elementos(Elemento) :-
    receta(Elemento, _).
elementos(Elemento) :-
    necesita(_, Elemento).

%Conocer quienGana, que es quien puede construir más cosas.
quienGana(Jugador):-
    elemento(Jugador, _),
    cantElementosConstruir(Jugador, Cant), 
    forall((cantElementosConstruir(Jugador2, Cantidad), Jugador2 \= Jugador), Cant >= Cantidad). 

cantElementosConstruir(Jugador, Cant):-
    elemento(Jugador, _),
    findall(Elemento, distinct(Elemento, puedeConstruir(Jugador, Elemento)), Elementos), 
    length(Elementos, Cant).

%Hacer una nueva versión del predicado puedeConstruir (se puede llamar puedeLlegarATener) para considerar todo lo que podría construir 
%si va combinando todos los elementos que tiene (y siempre y cuando tenga alguna herramienta que le sirva para construir eso). 
%Un jugador puede llegar a tener un elemento si o bien lo tiene, o bien tiene alguna herramienta que le sirva para hacerlo y cada 
%ingrediente necesario para construirlo puede llegar a tenerlo a su vez.
podriaConstruir(Jugador, Elemento) :-
    elemento(Jugador, Elemento).
  
podriaConstruir(Jugador, Elemento) :-
    elementos(Elemento), 
    elemento(Jugador, _),
    tieneHerramienta(Jugador,Elemento),
    forall(necesita(Elemento, Ingrediente), podriaConstruir(Jugador, Ingrediente)).