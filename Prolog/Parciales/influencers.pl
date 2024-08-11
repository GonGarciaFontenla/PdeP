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

contenido(ana, video(1, [evelyn, beto])).
contenido(ana, video(1, [])). 
contenido(ana, foto([])). 
contenido(beto, foto([])). 
contenido(cami, stream(leagueOfLegends)). 
contenido(cami, video(5, [])). 
contenido(evelyn, foto([cami])).

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

