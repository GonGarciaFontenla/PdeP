ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).

pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).

etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

marcaAuto(2008, peugeot). 
marcaAuto(3008, peugeot).
marcaAuto(countryman, mini).
marcaAuto(touareg, volkswagen).
marcaAuto(hilux,toyota).

marca(auto(Modelo), Marca):- marcaAuto(Modelo, Marca).
marca(cuatri(Marca), Marca).
marca(moto(Anio, _), ktm):- Anio >= 2000. 
marca(moto(Anio, _), yamaha):- Anio < 2000. 
marca(Camion, kamaz):- lleva(vodka, Camion).
marca(Camion, iveco):- esCamion(Camion), not(lleva(vodka, Camion)).

lleva(Item, camion(Items)):-
    member(Item, Items).

esCamion(camion(_)).

%b)¿Qué debo agregar si quiero decir que el modelo buggy es marca mini pero el modelo dkr no lo es? Justificar conceptualmente.
    %En la base de conocimiento, solamente se incluyen verdades absolutas, por ende no
    %se debe indicar un hecho que implique que el modelo dkr no es de la marca mini. 

%ganadorReincidente/1. Se cumple para aquel competidor que ganó en más de un año.
ganadorReincidente(Ganador):- 
    ganador(Anio, Ganador, _), 
    ganador(OtroAnio, Ganador, _), 
    Anio \= OtroAnio.

%inspiraA/2. Un conductor resulta inspirador para otro cuando ganó y el otro no, y también resulta inspirador cuando 
%ganó algún año anterior al otro. En cualquier caso, el inspirador debe ser del mismo país que el inspirado.
inspiraA(Inspirador, Inspirado):-
    mismoPais(Inspirador, Inspirado), 
    puedeInspirar(Inspirador, Inspirado).

puedeInspirar(Inspirador, Inspirado):-
    ganador(Anio, Inspirador, _), 
    not(ganador(Anio, Inspirado, _)). 

puedeInspirar(Inspirador, Inspirado):-
    ganador(AnioAnt, Inspirador, _), 
    ganador(AnioSig, Inspirado, _),
    AnioAnt < AnioSig.

mismoPais(P1, P2):- 
    pais(P1, Pais), 
    pais(P2,Pais), 
    P1 \= P2. 

%marcaDeLaFortuna/2. Relaciona un conductor con una marca si sólo ganó con vehículos de esa marca. Si un conductor nunca ganó, no debe tener marca de la fortuna.
    %La marca de un auto se obtiene a partir del modelo del auto. 
    %La marca de las motos dependen del año de fabricación: las fabricadas a partir del 2000 inclusive son ktm, las anteriores yamaha.
    %La marca de los camiones es kamaz si lleva vodka, sino la marca es iveco.
    %La marca del cuatri se indica en cada uno.
marcaDeLaFortuna(Conductor, Marca):-
    ganador(_,Conductor, Vehiculo),
    marca(Vehiculo, Marca),
    forall((ganador(_, Conductor, Vehiculo2), marca(Vehiculo2, Marca2)), Marca = Marca2). 

%heroePopular/1. Decimos que un corredor es un héroe popular cuando sirvió de inspiración a alguien, y además el 
%año que salió ganador fue el único de los conductores ganadores que no usó un vehículo caro.
    %Un vehículo es caro cuando es de una marca cara (por ahora las caras son mini, toyota e iveco), o tiene al menos tres suspensiones extras. 
    %La cantidad de suspensiones extras que trae una moto se indica en cada una, los cuatri llevan siempre 4, y los otros vehículos ninguna.
heroePopular(Corredor):-
    inspiraA(Corredor, _),
    unicoConAutoBarato(Corredor). 

unicoConAutoBarato(Corredor):-
    ganador(Anio, Corredor, _), 
    not(usoVehiculoCaro(Corredor, Anio)),
    forall(ganadorDiferente(Anio, Corredor, OtroCorredor), usoVehiculoCaro(OtroCorredor, Anio)). 

usoVehiculoCaro(Corredor, Anio):-
    ganador(Anio, Corredor, Vehiculo), 
    vehiculoCaro(Vehiculo).

ganadorDiferente(Anio, Corredor, OtroCorredor):- 
    ganador(Anio, Corredor, _), 
    ganador(Anio, OtroCorredor, _), 
    OtroCorredor \= Corredor. 
    
vehiculoCaro(Vehiculo):- 
    marca(Vehiculo, Marca), 
    marcaCara(Marca).

vehiculoCaro(Vehiculo):-
    suspensionesExtra(Vehiculo, Suspensiones), 
    Suspensiones >= 3. 

suspensionesExtra(cuatri(_), 4).
suspensionesExtra(moto(_, Suspensiones), Suspensiones).

marcaCara(toyota).
marcaCara(mini). 
marcaCara(iveco).

%Necesitamos un predicado que permita saber cuántos kilómetros existen entre dos locaciones distintas.
kmEntreLocaciones(L1, L2, Kms):-
    etapa(L1,L2,Kms).

kmEntreLocaciones(L1, L2, Kms):-
    etapa(L1, LocacionIntermedia, KmAnts), 
    kmEntreLocaciones(LocacionIntermedia, L2, KmRest), 
    Kms is KmAnts + KmRest.

%Saber si un vehículo puede recorrer cierta distancia sin parar. Por ahora (posiblemente cambie) diremos que un 
%vehículo caro puede recorrer 2000 km, mientras que el resto solamente 1800 km. Además, los camiones pueden también
%recorrer una distancia máxima igual a la cantidad de cosas que lleva * 1000.
recorrerSinParar(Vehiculo, Distancia):-
    distanciaMaximaPosible(Vehiculo, Limite), 
    Distancia =< Limite.

distanciaMaximaPosible(Vehiculo, 2000):-
    vehiculoCaro(Vehiculo).

distanciaMaximaPosible(Vehiculo, 1800):-
    vehiculo(Vehiculo),
    not(vehiculoCaro(Vehiculo)).

distanciaMaximaPosible(camion(Items), Kms):-
    length(Items, CantItems), 
    Kms is CantItems * 1000.

vehiculo(Vehiculo):-
    marca(Vehiculo, _).

%Los corredores quieren saber, dado un vehículo y un origen, cuál es el destino más lejano al que pueden llegar sin parar.
destinoMasLejano(Vehiculo, Origen, Destino):-
    puedeLlegarSinParar(Vehiculo, Origen, Destino), 
    forall(otroDestino(Vehiculo, Origen, Destino, OtroDestino), estaMasCerca(Origen, OtroDestino, Destino)).

puedeLlegarSinParar(Vehiculo, L1, L2):-
    kmEntreLocaciones(L1, L2, Km), 
    recorrerSinParar(Vehiculo, Km). 

otroDestino(Vehiculo, L1, L2, L3):-
    puedeLlegarSinParar(Vehiculo, L1, L2), 
    puedeLlegarSinParar(Vehiculo, L1, L3),
    L2 \= L3.

estaMasCerca(L1, L2, L3):-
    kmEntreLocaciones(L1, L2, Km1), 
    kmEntreLocaciones(L1, L3, Km2), 
    Km1 < Km2.
    

