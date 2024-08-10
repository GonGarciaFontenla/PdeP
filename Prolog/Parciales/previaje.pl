comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).
% Nuevos comercios adheridos
comercioAdherido(ushuaia, finDelMundoHotel).
comercioAdherido(ushuaia, canalBeagleTour).
comercioAdherido(bariloche, cerroCatedralSki).
comercioAdherido(cordoba, hotelCordobaCenter).
comercioAdherido(cordoba, aerolineas).

factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).
% Nuevas facturas
factura(mariana, hotel(finDelMundoHotel, 4500)).
factura(juan, vuelo(2020, juanPerez)).
factura(mariana, excursion(canalBeagleTour, 6000, 3)).
factura(sofia, hotel(hotelCordobaCenter, 5500)).  % Factura trucha por exceder el máximo permitido

valorMaximoHotel(5000).

registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).
% Nuevos registros de vuelos
registroVuelo(2020, ushuaia, aerolineas, [juanPerez, mariaGomez], 12000).

%Porcentaje de devolucion por factura. 
devolucion(hotel(_,_), 0.5).

devolucion(vuelo(NumeroVuelo, _), 0.3):- 
    registroVuelo(NumeroVuelo, Destino, _, _, _), 
    Destino \= buenosAires. 

devolucion(vuelo(NroDeVuelo, _), 0):-
    registroVuelo(NroDeVuelo, buenosAires, _, _,_).

devolucion(excursion(_, _, CantPersonas), Devolucion) :-
    Devolucion is 0.8 / CantPersonas.
    

%Facturas truchas.
facturaTrucha(Factura):-
    comercio(Factura, Comercio), 
    not(comercioAdherido(_, Comercio)). 

facturaTrucha(hotel(_, Monto)):-
    valorMaximoHotel(ValorMaximo),
    Monto > ValorMaximo. 

facturaTrucha(vuelo(NumeroVuelo, Pasajero)):- 
    registroVuelo(NumeroVuelo, _, _, Pasajeros, _), 
    not(member(Pasajero, Pasajeros)).

comercio(hotel(Comercio, _), Comercio). 

comercio(excursion(Comercio, _, _), Comercio). 

comercio(vuelo(NumeroVuelo, _), Comercio):-
    comercioAdherido(_, Comercio),
    registroVuelo(NumeroVuelo, _, Comercio, _, _). 

/*
El dinero que se le devuelve a una persona se calcula sumando la devolución
correspondiente a cada una de las facturas válidas (que no sean truchas), más un adicional
de $1000 por cada ciudad diferente en la que se alojó (con factura válida). Hay una
penalidad de $15000 si entre todas las facturas presentadas hay alguna que sea trucha.
Además, el monto máximo a devolver es de $100000.
*/
montoDevolverPersona(Persona, MontoTotal):-
    factura(Persona, _), 
    montoPorFacturas(Persona, MontoFacturas), 
    montoPorCiudadesDiferentes(Persona, MontoCiudades), 
    montoDePenalidad(Persona, MontoPenalidad), 
    MontoTotal is MontoFacturas + MontoCiudades - MontoPenalidad.

montoPorFacturas(Persona, MontoPorFacturas):-
    findall(Monto, montoDevolucionPorFactura(Persona, Monto), ListaMontos), 
    sum_list(ListaMontos, MontoPorFacturas). 

montoDevolucionPorFactura(Persona, MontoPorDevolucion):-
    factura(Persona, DetalleFactura), 
    not(facturaTrucha(DetalleFactura)), 
    devolucion(DetalleFactura, PorcentajeDevolucion),
    montoFactura(DetalleFactura, MontoFactura), 
    MontoPorDevolucion is MontoFactura * PorcentajeDevolucion. 

montoFactura(hotel(_, Monto), Monto). 

montoFactura(excursion(_, Monto, _), Monto). 

montoFactura(vuelo(Num, _), Monto):-
    registroVuelo(Num,_, _, _, Monto). 

montoPorCiudadesDiferentes(Persona, MontoCiudadesDiferentens):-
    factura(Persona, DetalleFactura), 
    not(facturaTrucha(DetalleFactura)),
    findall(Ciudad, (factura(Persona, Factura), ciudades(Factura, Ciudad)), Ciudades), 
    sort(Ciudades, CiudadesDiferentes),
    length(CiudadesDiferentes, CantCiudades), 
    MontoCiudadesDiferentens is 1000 * CantCiudades.

ciudades(hotel(Comercio, _),Ciudad):-
    comercioAdherido(Ciudad, Comercio). 

ciudades(excursion(Comercio, _, _), Ciudad):-
    comercioAdherido(Ciudad, Comercio). 
    
ciudades(vuelo(Num, _), Ciudad):-
    registroVuelo(Num, Ciudad, _, _, _).

montoDePenalidad(Persona, 0) :-
    factura(Persona, DetalleDeFactura),
    not(facturaTrucha(DetalleDeFactura)).
    
montoDePenalidad(Persona, 15000) :-
    factura(Persona, DetalleDeFactura),
    facturaTrucha(DetalleDeFactura).

%Qué destinos son sólo de trabajo. Son aquellos destinos que si bien tuvieron vuelos
%hacia ellos, no tuvieron ningún turista que se alojen allí o tienen un único hotel adherido.
destinoSoloTrabajo(Destino):-
    registroVuelo(_, Destino, _, _, _),
    nadieAlojo_UnicoHotel(Destino).

nadieAlojo_UnicoHotel(Destino):- 
    noTuvoTuristas(Destino).

nadieAlojo_UnicoHotel(Destino):-
    unicoHotelAdherido(Destino). 

noTuvoTuristas(Destino):- 
    forall(comercioAdherido(Destino, Hotel), not(factura(_, hotel(Hotel, _)))). 

unicoHotelAdherido(Destino):-
    findall(Hotel, (comercioAdherido(Destino,Hotel), factura(_,hotel(Hotel,_))), ListaHoteles), 
    list_to_set(ListaHoteles, Hoteles), 
    length(Hoteles, 1). 
    
%Saber quiénes son estafadores, que son aquellas personas que sólo presentaron facturas truchas o facturas de monto 0.
esEstafador(Persona):-
    factura(Persona, _),
    forall(factura(Persona, Factura), facturaTrucha_MontoCero(Factura)). 

facturaTrucha_MontoCero(Factura):-
    facturaTrucha(Factura). 
facturaTrucha_MontoCero(hotel(_, 0)). 
facturaTrucha_MontoCero(excursion(_,0,_)).
facturaTrucha_MontoCero(viajes(NumVuelo, _)):-
    registroVuelo(NumVuelo,_,_,_,0).