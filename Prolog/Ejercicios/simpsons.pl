%enunciado: https://docs.google.com/document/d/1tDGNkEUPBEzBPdQNfGEVoh39DSdf0M7X25-tG6r4VHs/edit

%padreDe(Padre, Hijo)
padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).

%madreDe(Madre, Hijo)
madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge, maggie).
madreDe(selma, ling).

%Punto 1:
%tieneHijo/1:
tieneHijo(Personaje) :-
    padreDe(Personaje, _).

tieneHijo(Personaje) :-
    madreDe(Personaje, _).

%hermanos/2:
hermanos(Hermano1, Hermano2) :-
    compartenPadre(Hermano1, Hermano2),
    compartenMadre(Hermano1, Hermano2).

compartenPadre(Persona, OtraPersona) :-
    Persona \= OtraPersona,
    padreDe(Padre, Persona),
    padreDe(Padre, OtraPersona).

compartenMadre(Persona, OtraPersona) :-
    Persona \= OtraPersona,
    madreDe(Madre, Persona),
    madreDe(Madre, OtraPersona).

%medioHermanos/2:
medioHermanos(MedioHermano1, MedioHermano2) :-
    compartenPadre(MedioHermano1, MedioHermano2).

medioHermanos(MedioHermano1, MedioHermano2) :-
    compartenMadre(MedioHermano1, MedioHermano2).

%tioDe/2:
/*es tio si:
es hermano de alguno de sus padres
o
su pareja o expareja es hermano de alguno de los padres
*/
tioDe(Tio, Sobrino) :-
    padreDe(Padre, Sobrino),
    hermanos(Padre, Tio).

tioDe(Tio, Sobrino) :-
    madreDe(Madre, Sobrino),
    hermanos(Madre, Tio).

tioDe(Tio, Sobrino) :-
    padreDe(Padre, Sobrino),
    parejaDelHermano(Padre, Tio).

tioDe(Tio, Sobrino) :-
    madreDe(Madre, Sobrino),
    parejaDelHermano(Madre, Tio).

%parejaDelHermano(Persona, ParejaDeSuHermano) nos dice si la segunda persona es pareja de algún hermano de la primera
parejaDelHermano(Persona, ParejaDeSuHermano) :-
    hermano(Persona, HermanoDeLaPersona),
    pareja(HermanoDeLaPersona, ParejaDeSuHermano).

%pareja(Persona, OtraPersona) (también contempla aquellos que ya no están juntos)
pareja(abe, edwina).
pareja(abe, mona).
pareja(abe, gaby).
pareja(edwina, abe).
pareja(mona, abe).
pareja(gaby, abe).
pareja(homero, marge).
pareja(marge, homero).
pareja(clancy, jacqueline).
pareja(jacqueline, clancy).

%abueloMultiple/2:
abueloMultiple(Abuelo) :-
    abueloDe(Abuelo, Persona1),
    abueloDe(Abuelo, Persona2),
    Persona1 \= Persona2.

abueloDe(Abuelo, Nieto) :-
    progenitorDe(ProgenitorNieto, Nieto),
    hijoDe(ProgenitorNieto, Abuelo).

progenitorDe(Progenitor, Hijo) :-
    padreDe(Progenitor, Hijo).

progenitorDe(Progenitor, Hijo) :-
    madreDe(Progenitor, Hijo).

hijoDe(Hijo, Progenitor) :-
    progenitorDe(Progenitor, Hijo).

%Punto 2:
%descendiente/2:
descendiente(Descendiente, Ancestro) :-
    progenitorDe(Ancestro, Descendiente).

descendiente(Descendiente, AncestroMasViejoConocido) :-
    progenitorDe(AncestroMasViejoConocido, OtroAncestro),
    descendiente(Descendiente, OtroAncestro).