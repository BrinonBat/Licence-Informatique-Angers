% 1. En se basant sur la librairie pour les graphes orientés développée
%en TP définir le prédicat chemin qui est tel que chemin(U,V,G,C) est
%vrai si C est un chemin (la liste des nœuds du graphe G) menant du
%sommet U au sommet V.

% Exemple :
%% ?- G =
graphe([sommet(a,[b]),sommet(b,[e,c,f]),sommet(c,[d,g]),sommet(d,[c,h]),sommet(e,[a,f]),sommet(f,[g]),sommet(g,[f]),sommet(h,[d,g])]),
chemin(a,g,G,C).
%% G = graphe([sommet(a, [b]), sommet(b, [e, c, f]), sommet(c, [d, g]),
sommet(d, [c, h]), sommet(e, [a, f]), sommet(f, [g]), sommet(g, [...]),
sommet(..., ...)]),
%% C = [a, b, e, f, g] ;
%% G = graphe([sommet(a, [b]), sommet(b, [e, c, f]), sommet(c, [d, g]),
sommet(d, [c, h]), sommet(e, [a, f]), sommet(f, [g]), sommet(g, [...]),
sommet(..., ...)]),
%% C = [a, b, c, d, h, g] ;
%% G = graphe([sommet(a, [b]), sommet(b, [e, c, f]), sommet(c, [d, g]),
sommet(d, [c, h]), sommet(e, [a, f]), sommet(f, [g]), sommet(g, [...]),
sommet(..., ...)]),
%% C = [a, b, c, g] ;
%% G = graphe([sommet(a, [b]), sommet(b, [e, c, f]), sommet(c, [d, g]),
sommet(d, [c, h]), sommet(e, [a, f]), sommet(f, [g]), sommet(g, [...]),
sommet(..., ...)]),
%% C = [a, b, f, g] ;
%% false.

% 2. Définir le prédicat cycles/3 qui est tel que cycles(S,G,LC) est
%vrai si LC est l'ensemble des cycles du graphe G contenant S. (Que l'on
%déduira du prédicat chemin ci-dessus en allant lire la partie sur les
%prédicats ensemblistes du cours « extralogique ».)

% Exemple :
%% ?- G =
graphe([sommet(a,[b]),sommet(b,[e,c,f]),sommet(c,[d,g]),sommet(d,[c,h]),sommet(e,[a,f]),sommet(f,[g]),sommet(g,[f]),sommet(h,[d,g])]),
cycles(d,G,LC).
%% G =
graphe([sommet(a,[b]),sommet(b,[e,c,f]),sommet(c,[d,g]),sommet(d,[c,h]),sommet(e,[a,f]),sommet(f,[g]),sommet(g,[f]),sommet(h,[d,g])]),
%% LC = [[c,d],[h,d]] ;
%% false.

% 3. Définir le prédicat cycles/2 qui est tel que cycles(G,LC) est vrai
%si LC est l'ensemble des cycles d'un graphe G. (On fera comme pour la
%question 2 mais la liste résultat contiendra des doublons, à une
%permutation près, qu'il faudra éliminer.)

% Exemple :
%% ?- G =
graphe([sommet(a,[b]),sommet(b,[e,c,f]),sommet(c,[d,g]),sommet(d,[c,h]),sommet(e,[a,f]),sommet(f,[g]),sommet(g,[f]),sommet(h,[d,g])]),
cycles(G,LC).
%% G =
graphe([sommet(a,[b]),sommet(b,[e,c,f]),sommet(c,[d,g]),sommet(d,[c,h]),sommet(e,[a,f]),sommet(f,[g]),sommet(g,[f]),sommet(h,[d,g])]),
%% LC = [[d,c],[d,h],[e,a,b],[g,f]] ;
%% false.

%En théorie des graphes, une composante fortement connexe d'un graphe
%orienté G est un sous-graphe de G possédant la propriété suivante, et
%qui est maximal pour cette propriété : pour tout couple (u, v) de nœuds
%dans ce sous-graphe, il existe un chemin de u à v. [Wikipedia]

% 4. Déduire du prédicat cycles/2 le prédicat cfc/2 qui est tel que
%cfc(G,CFC) est vrai si la CFC est la liste des composantes fortement
%connexes du graphe G.

% 5. L'algorithme de Tarjan calcule aussi les composantes fortement
%connexes d'un graphe mais réalise un parcours optimisé des nœuds. Il est
%en cela beaucoup moins naïf et beaucoup plus efficace que celui spécifié
%précédemment. Définir un nouveau prédicat tarjan/2 qui calcule selon
%l'algorithme de Tarjan les composantes fortement connexes d'un graphe
%orienté.

%% ?- G =
graphe([sommet(a,[b]),sommet(b,[e,c,f]),sommet(c,[d,g]),sommet(d,[c,h]),sommet(e,[a,f]),sommet(f,[g]),sommet(g,[f]),sommet(h,[d,g])]),
tarjan(G,CFC).
%% G = graphe([sommet(a, [b]), sommet(b, [e, c, f]), sommet(c, [d, g]),
sommet(d, [c, h]), sommet(e, [a, f]), sommet(f, [g]), sommet(g, [...]),
sommet(..., ...)]),
%% CFC = [[e, b, a], [h, d, c], [g, f]] ;
%% false.

%% Une directive pour modifier la sortie standard
:- set_prolog_flag(answer_write_options, [quoted(true), portray(true),
max_depth(100), attributes(portray)]).
