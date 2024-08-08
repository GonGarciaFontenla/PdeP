restaurante(panchoMayo, 2, barracas).
restaurante(finoli, 3, villaCrespo).
restaurante(superFinoli, 5, villaCrespo).

menu(panchoMayo, carta(1000, pancho)).
menu(panchoMayo, carta(200, hamburguesa)).
menu(finoli, carta(2000, hamburguesa)).
menu(finoli, pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos(2, 3000, [guinoPin, juanaDama],3)).

vino( chateauMessi, francia, 5000).
vino( francescoliSangiovese, italia, 1000).
vino( susanaBalboaMalbec, argentina, 1200).
vino( christineLagardeCabernet, argentina, 5200).
vino( guinoPin, argentina, 500).
vino( juanaDama, argentina, 1000).

%Cuáles son los restaurantes de más de N estrellas por barrio.
superaNestrellas(Restaurantes, N, Barrio) :-
    restaurante(_, _, Barrio), %Inversibilidad
    findall(Restaurante, (restaurante(Restaurante, Estrellas, Barrio), Estrellas > N), Restaurantes). 

%Cuáles son los restaurantes sin estrellas.
sinEstrellas(Restaurantes) :-
    findall(Restaurante, (menu(Restaurante, _), not(restaurante(Restaurante, _,_))), Restaurantes).

%Si un restaurante está mal organizado, que es cuando tiene algún menú que tiene más pasos que la cantidad
%de vinos disponibles o cuando tiene en su menú a la carta dos veces una misma comida con diferente precio.
malOrganizado(Restaurante):-
    menu(Restaurante, carta(Precio1,Comida)),
    menu(Restaurante, carta(Precio2, Comida)), 
    Precio1 \= Precio2.  

malOrganizado(Restaurante):-
    menu(Restaurante, pasos(Pasos,_ , Vinos, _)), 
    length(Vinos, CantVinos),
    Pasos > CantVinos. 
     

