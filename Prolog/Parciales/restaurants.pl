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

%Qué restaurante es copia barata de qué otro restaurante, lo que sucede cuando el primero tiene todos los platos
%a la carta que ofrece el otro restaurante, pero a un precio menor. Además, no puede tener más estrellas que el otro. 
copiaBarata(RestoCopia, RestoCopiado):-
    menu(RestoCopia, _), 
    menu(RestoCopiado,_),
    RestoCopia \= RestoCopiado,
    forall(menu(RestoCopiado, carta(PrecioCopiado, Menu)), (menu(RestoCopia, carta(PrecioCopia, Menu)), PrecioCopia < PrecioCopiado)), 
    menosEstrellas(RestoCopia, RestoCopiado). 

menosEstrellas(R1, R2):-
    restaurante(R1,Estrellas, _), 
    restaurante(R2, Estrellas2,_), 
    Estrellas < Estrellas2.  
    
%Cuál es el precio promedio de los menúes de cada restaurante, por persona. 
    %En los platos, se considera el precio indicado ya que se asume que es para una persona.
    %En los menú por pasos, el precio es el indicado más la suma de los precios de todos los vinos incluidos, pero dividido
    %en la cantidad de comensales. Los vinos importados pagan una tasa aduanera del 35% por sobre su precio publicado.
precioPromedio(Restaurante, PrecioProm):-
    menu(Restaurante, _), 
    calcularPromedioPrecio(Restaurante, PrecioProm). 


