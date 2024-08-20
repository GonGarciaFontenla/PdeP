necesidades(respiracion, fisiologico).
necesidades(alimentacion, fisiologico).
necesidades(descanso, fisiologico).
necesidades(reproduccion, fisiologico).
necesidades(integridadFisica, seguridad).
necesidades(empleo, seguridad).
necesidades(salud, seguridad).
necesidades(amistad, social).
necesidades(afecto, social).
necesidades(intimidad, social).
necesidades(confianza, reconocimiento). 
necesidades(respecto, reconocimiento). 
necesidades(exito, reconocimiento).
necesidades(exitoEconomico, autorrealizacion).
necesidades(exitoAmoroso, autorrealizacion).
necesidades(proposito, autorrealizacion).
%Ejemplo para manuel.
necesidades(libertad, autorrealizacion).
%Nivel agregado por mi. 
necesidades(estabilidad, conformismo).
necesidades(aceptacionSocial, conformismo).

%nivelSuperior(mayorJerarquia, menorJerarquia). 
nivelSuperior(conformismo, autorrealizacion). 
nivelSuperior(autorrealizacion, reconocimiento). 
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

%Permitir averiguar la separación de niveles que hay entre dos necesidades, es decir la cantidad de niveles que hay entre una y otra.
separacionNecesidades(Necesidad1, Necesidad2, CantNiveles):-
    necesidades(Necesidad1, LevelNece1), 
    necesidades(Necesidad2, LevelNece2),
    separacionNiveles(LevelNece1, LevelNece2, CantNiveles). 

separacionNiveles(Nivel, Nivel, 0). %Para cortar recursividad. 

separacionNiveles(Nivel1, Nivel2, Cant):-
    nivelSuperior(Nivel2, NivelIntermedio), 
    separacionNiveles(Nivel1, NivelIntermedio, CantAnterior), 
    Cant is CantAnterior + 1.     

%Modelar las necesidades (sin satisfacer) de cada persona.
necesidad(carla, alimentacion). 
necesidad(carla, descanso). 
necesidad(carla, empleo). 
necesidad(juan, afecto). 
necesidad(roberto, amistad). 
necesidad(manuel, libertad). 
necesidad(charly, afecto). 

%%-----Variante 1------%% 
%Encontrar la necesidad de mayor jerarquía de una persona.
necesidadMayorJerarquia(Persona,Necesidad):-
    necesidad(Persona,Necesidad),
    not((necesidad(Persona,OtraNecesidad),
        mayorJerarquia(OtraNecesidad,Necesidad))).

mayorJerarquia(Necesidad1,Necesidad2):-
    separacionNecesidades(Necesidad2,Necesidad1,Separacion),
    Separacion > 0.

%%-----Variante 2------%% 
%Esta opcion me gusta mas --> Partiendo del nivel mas bajo (fisiologica), calcula la separacion entre este y el 
%nivel de todas las necesidades, aquel que tenga un nivel de sepracion mayor al resto, tiene la mayor jerarquia. 
necesidadMayorJerarquia2(Persona,Necesidad):-
    jerarquiaNecesidad(Persona,Necesidad,JerarquiaMax),
    forall(jerarquiaNecesidad(Persona,_,OtraJerarquia), JerarquiaMax >= OtraJerarquia).    

jerarquiaNecesidad(Persona,Necesidad,Jerarquia):-
    necesidad(Persona,Necesidad),
    necesidades(Necesidad,Nivel),
    nivelBasico(NivelBasico),
    separacionNiveles(NivelBasico,Nivel,Jerarquia).

nivelBasico(Nivel):-
    nivelSuperior(_,Nivel),
    not(nivelSuperior(Nivel,_)).

%Saber si una persona pudo satisfacer por completo algún nivel de la pirámide.
satisfacerNivel(Persona, Nivel):-
    necesidad(Persona, _), 
    necesidades(_, Nivel),
    findall(Necesidad, necesidades(Necesidad, Nivel), NecesidadesNivel),
    forall(member(Necesidad, NecesidadesNivel), not(necesidad(Persona, Necesidad))).

%Teoria de Maslow: Las personas sólo atienden necesidades superiores cuando han satisfecho las necesidades inferiores.
%Definir los predicados que permitan analizar si es cierta o no la teoría de Maslow:
%a) Para una persona en particular.
cumpleTeoriaPersona(Persona):-
    necesidad(Persona, Necesidad), 
    forall(necesidad(Persona, OtraNecesidad), mismoNivel(Necesidad, OtraNecesidad)).

mismoNivel(Necesidad, Necesidad2):- separacionNecesidades(Necesidad, Necesidad2, 0).

%b)Para todas las personas.
cumplenTeoriaPersonas:-
    forall(necesidad(Persona,_), cumpleTeoriaPersona(Persona)).

%c)Para la mayoria de las personas. 
cumplenTeoriaMayoria:-
    findall(Persona, necesidad(Persona, _), Personas), 
    list_to_set(Personas, UnicasPersonas), 
    length(UnicasPersonas, CantPersonas), 
    findall(Persona1, (member(Persona1, UnicasPersonas), cumpleTeoriaPersona(Persona1)), CumplenTeoria), 
    length(CumplenTeoria, CantCumplenTeoria), 
    CantCumplenTeoria >  (CantPersonas / 2).