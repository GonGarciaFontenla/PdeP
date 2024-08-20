adopto(martin, pepa, 2014). 
adopto(martin, olivia, 2014). 
adopto(martin, frida, 2015). 
adopto(martin, kali, 2016). 
adopto(constanza, mambo, 2015). 
adopto(hector, abril, 2015). 
adopto(hector, mambo, 2015). 
adopto(hector, buenaventura, 1971). 
adopto(hector, severino, 2007). 
adopto(hector, simon,  2016). 

compro(martin, piru, 2010). 
compro(hector, abril, 2006). 

regalo(constanza, abril, 2006). 
regalo(silvio, quinchin, 1990). 

mascota(pepa, perro(mediano)).
mascota(frida, perro(grande)).
mascota(piru, gato(macho,15)).
mascota(kali, gato(macho,3)).
mascota(olivia, gato(hembra,16)).
mascota(mambo, gato(macho,2)).
mascota(abril, gato(hembra,4)).
mascota(buenaventura, tortuga(agresiva)).
mascota(severino, tortuga(agresiva)).
mascota(simon, tortuga(tranquila)).
mascota(quinchin, gato(macho,0)).

mascotas(Persona, Mascota, Anio):- adopto(Persona, Mascota, Anio). 
mascotas(Persona, Mascota, Anio):- compro(Persona, Mascota, Anio). 
mascotas(Persona, Mascota, Anio):- regalo(Persona, Mascota, Anio). 

%Al consultar si Constanza adoptó a mambo en el 2008 debe dar falso. Justificar conceptualmente lo que fue necesario hacer para conseguirlo.
    %Gracias al concepto de universo cerrado, todo aquello que no forme parte de la base de conocimiento es considerado falso. 

%comprometidos/2 se cumple para dos personas cuando adoptaron el mismo año a la misma mascota. 
comprometidos(Persona1, Persona2):-
    adopto(Persona1, Animal, Anio), 
    adopto(Persona2, Animal, Anio), 
    Persona1 \= Persona2. 

%locoDeLosGatos/1 se cumple para una persona cuando tiene sólo gatos, pero más de uno.
locoDeLosGatos(Persona):-
    adopto(Persona, _, _), 
    soloGatos(Persona), 
    masDeUnGato(Persona). 

soloGatos(Persona):-
    forall(mascotas(Persona, Mascota, _), mascota(Mascota, gato(_, _))), 
    mascotas(Persona, Mascota, _), 
    mascotas(Persona, Mascota2, _), 
    Mascota \= Mascota2.

masDeUnGato(Persona):-
    mascotas(Persona, Mascota, _), 
    mascotas(Persona, Mascota2, _), 
    Mascota \= Mascota2.

%puedeDormir/1 Se cumple para una persona si no tiene mascotas que estén chapita (los perros chicos y las tortugas están chapita, 
%y los gatos machos que fueron acariciados menos de 10 veces están chapita). 
puedeDormir(Persona):-
    adopto(Persona, _, _), 
    forall((mascotas(Persona, Mascota, _), mascota(Mascota, Animal)), not(mascotaChapita(Animal))). 

mascotaChapita(perro(chico)).
mascotaChapita(tortuga(_)). 
mascotaChapita(gato(_, Mimos)):- Mimos < 10.  

%crisisNerviosa/2 es cierto para una persona y un año cuando, el año anterior obtuvo una mascota que está chapita y ya antes tenía otra mascota que está chapita. 
crisisNerviosa(Persona, AnioCrisis):-
    mascotas(Persona, _, Anio),
    adoptoChapitaAnioAnterior(Persona, Anio, AnioAnt), 
    adoptoChapitaAnioPrevio(Persona, AnioAnt), 
    AnioCrisis is Anio + 1.

adoptoChapitaAnioAnterior(Persona, Anio, AnioAnt):- 
    AnioAnt is  Anio - 1, 
    mascotas(Persona, Mascota, AnioAnt), 
    mascota(Mascota, Animal),
    mascotaChapita(Animal).

adoptoChapitaAnioPrevio(Persona, AnioAnt):-
    mascotas(Persona, Mascota, AnioPrevio),
    AnioPrevio < AnioAnt,
    mascota(Mascota, Animal),
    mascotaChapita(Animal).

%Decir si es inversible (si se pueden hacer preguntas existenciales) y por qué.
    %El predicado si es inversible, esto se debe a que la consulta "adopto(Persona, _, Anio)" es capaz de generar todos los posibles casos 
    %que pueden cumplir crisisNerviosa, entonces el resto de las consultas dejan de ser existenciales para pasar a ser individuales. 

%mascotaAlfa/2 Relaciona una persona con el nombre de una mascota, cuando esa mascota domina al resto de las mascotas de esa persona. 
%Se sabe que un gato siempre domina a un perro, que un perro grande domina a uno chico, que un gato chapita domina a gatos no chapita, 
%y que una tortuga agresiva domina cualquier cosa. 
mascotaAlfa(Persona, Mascota):-
    mascotas(Persona, Mascota, _), 
    forall((mascotas(Persona, OtraMascota, _), Mascota \= OtraMascota), dominante(Mascota, OtraMascota)). 

dominante(Mascota, Mascota2):- 
    mascota(Mascota, Animal),
    mascota(Mascota2, Animal2), 
    domina(Animal, Animal2). 

domina(tortuga(agresiva), _). 
domina(gato(_, _), perro(_)). 
domina(perro(grande), perro(chico)). 
domina(gato(_, Mimos1), gato(_, Mimos2)) :- 
    Mimos1 < 10,
    Mimos2 >= 10.

%materialista/1 se cumple para una persona cuando no tiene mascotas o compró más de las que adoptó. Hacer que sea inversible. 
materialista(Persona):-
    not(mascotas(Persona, _, _)). 

materialista(Persona):-
    mascotas(Persona, _, _),
    mascotasCompradas(Persona, Compradas), 
    mascotasAdoptadas(Persona, Adoptadas), 
    Compradas > Adoptadas. 

mascotasCompradas(Persona, Compradas):-
    findall(Mascota, compro(Persona, Mascota, _), Mascotas), 
    length(Mascotas, Compradas). 

mascotasAdoptadas(Persona, Adoptadas):-
    findall(Mascota, adopto(Persona, Mascota, _), Mascotas), 
    length(Mascotas, Adoptadas). 

