%red(Influencer, Plataforma, Seguidores). 
red(ana, youtube, 3000000).
red(ana, instagram, 2700000).  
red(ana, tiktok, 1000000).
red(ana, twitch, 2). 
red(beto, twitch, 120000). 
red(beto, youtube, 6000000).
red(beto, instagram, 1100000).  
red(cami, tiktok, 2000).
red(dani, youtube, 1000000).  
red(evelyn, instagram, 1).

contenido(ana, tiktok, video(1, [evelyn, beto])).
contenido(ana, tiktok, video(1, [ana])). 
contenido(ana, instagram, foto([ana])). 
contenido(beto, instagram, foto([])). 
contenido(cami, twitch, stream(leagueOfLegends)). 
contenido(cami, youtube, video(5, [cami])). 
contenido(evelyn, instagram, foto([evelyn, cami])).

tematica(juegos, leagueOfLegends).
tematica(juegos, minecraft).
tematica(juegos, aoe).

%influencer/1 se cumple para un usuario que tiene más de 10.000 seguidores en total entre todas sus redes.
influencer(Influencer):-
    red(Influencer, _, _), 
    seguidoresTotales(Influencer, Followers), 
    Followers > 10000. 

seguidoresTotales(Influencer, Followers):-
    findall(Seguidores, red(Influencer, _, Seguidores), CantSeguidores), 
    sum_list(CantSeguidores, Followers). 

%omnipresente/1 se cumple para un influencer si está en cada red que existe
omnipresente(Influencer):-
    red(Influencer, _, _), 
    forall(red(_, Red, _), red(Influencer, Red, _)). 
    
%exclusivo/1 se cumple cuando un influencer está en una única red.
exclusivo(Influencer):-
    red(Influencer, Red, _), 
    not((red(Influencer, Red2, _), Red \= Red2)).

%adictiva/1 se cumple para una red cuando sólo tiene contenidos adictivos (Un contenido adictivo es un video de 
%menos de 3 minutos, un stream sobre una temática relacionada con juegos, o una foto con menos de 4 participantes).
adictiva(Red):-
    contenido(_, Red, Contenido), 
    contenidoAdictivo(Contenido). 

contenidoAdictivo(video(Duracion, _)):- Duracion < 3. 
contenidoAdictivo(stream(Tematica)):- tematica(juegos, Tematica). 
contenidoAdictivo(foto(Integrantes)):- length(Integrantes, CantIntegrantes), CantIntegrantes < 4. 

%colaboran/2 se cumple cuando un usuario aparece en las redes de otro (en alguno de sus contenidos). En un stream siempre aparece quien creó el contenido.
%Esta relación debe ser simétrica. (O sea, si a colaboró con b, entonces también debe ser cierto que b colaboró con a)
colaboran(User1, User2):-
    participanEnRedes(User1, User2). 

colaboran(User1, User2):-
    participanEnRedes(User2, User1). 

participanEnRedes(U1, U2):- 
    contenido(U1, _, Contenido), 
    aparece(U1, Contenido, U2). 

aparece(U1, Contenido,U2):- 
    figuraEn(U1, Contenido, Participantes),
    member(U2, Participantes). 

figuraEn(_, foto(Participantes), Participantes). 
figuraEn(_, video(_, Participantes), Participantes). 
figuraEn(Autor, stream(_), [Autor]). 
    
%caminoALaFama/1 se cumple para un usuario no influencer cuando un influencer publicó contenido en el que aparece el usuario, o bien el influencer 
%publicó contenido donde aparece otro usuario que a su vez publicó contenido donde aparece el usuario. Debe valer para cualquier nivel de indirección.
caminoALaFama(Usuario):-
    participanEnRedes(Influencer, Usuario), 
    Influencer \= Usuario, 
    not(influencer(Usuario)), 
    tieneFama(Influencer). 

tieneFama(Usuario):- 
    influencer(Usuario). 

tieneFama(Usuario):-
    caminoALaFama(Usuario). %Si influencer no es influencer (valga la redundancia), lo toma como nuevo usuario. Intenta formar cadena indirecta. 

%Robo otra version --> Hecha por Alf. 
caminoALaFamaV2(Usuario):-
    loPublica(Usuario, Publicador),
    influencer(Publicador).

caminoALaFamaV2(Usuario):-
    loPublica(Usuario, Publicador),
    caminoALaFamaV2(Publicador).

loPublica(Usuario, Publicador):-
    participanEnRedes(Publicador, Usuario),
    Publicador \= Usuario,
    not(influencer(Usuario)).

%b)¿Qué hubo que hacer para modelar que beto no tiene tiktok? Justificar conceptualmente.
    %Gracias a la idea de universo cerrado, en la base de conocimiento solo se requiere poner aquellos hechos que sean verdades. 
    %Todo aquello que no este declarado en la base de conocimiento, se considera falso. Es por esa razon, que no es necesario modelar
    %mediante un hecho que beto no cuenta con tik tok. 