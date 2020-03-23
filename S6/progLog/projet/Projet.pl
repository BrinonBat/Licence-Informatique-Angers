mongraphe(graphe([sommet(a,[b,c]),sommet(b,[d]),sommet(c,[e]), sommet(e,[a]), sommet(d, [c])])).

graphedeux(graphe([sommet(b,[d,e]),sommet(c,[d,e]), sommet(e,[a,e]), sommet(d, [])])).

autregraphe(graphe([sommet(a,[b]), sommet(b,[c])])).



graphevide(graphe([])).


sommets(graphe(L), S) :- sommets_rec(L, S).

sommets_rec([], []).
sommets_rec([sommet(E, _) | L], [E|S]) :- sommets_rec(L, S).


membre(X, [X | _]).
membre(X, [_ | L]) :- membre(X, L).

successeurs(S, graphe(L), Succ_S) :- membre(sommet(S, Succ_S), L).

%successeurs(E, graphe(L), Succ) :- successeurs_rec(E, L, Succ).
%successeurs_rec(E, [sommet(E, Succ) | _], Succ).
%successeurs_rec(E, [_|L], Succ) :- successeurs_rec(E, L, Succ).


predecesseurs(E, graphe(L), Pred) :- sommets(graphe(L), S), membre(E, S), predecesseurs_rec(E, L, Pred).

predecesseurs_rec(_E, [], []).
predecesseurs_rec(E, [sommet(_, Succ) | L], Pred) :- (\+(membre(E, Succ))), predecesseurs_rec(E, L, Pred).
predecesseurs_rec(E, [sommet(E_, Succ) | L], [E_ | Pred]) :- membre(E, Succ), predecesseurs_rec(E, L, Pred).



insertion(L, X, [X | L]).
insertion([Y | L1], X, [Y | L2]) :- insertion(L1, X, L2).


ote_sommet(E, graphe(L), graphe(L_)) :- sommets(graphe(L), S), membre(E, S), ote_sommet_rec(E, L, L_).

ote_sommet_rec(_E, [], []).
ote_sommet_rec(E, [sommet(E, _) | L], L_) :- ote_sommet_rec(E, L, L_).
ote_sommet_rec(E, [sommet(E_, Succ) | L], [sommet(E_, Succ) | L_]) :- E \= E_, (\+(membre(E, Succ))), ote_sommet_rec(E, L, L_).
ote_sommet_rec(E, [sommet(E_, Succ) | L], [sommet(E_, Succ_) | L_]) :- E \= E_, membre(E, Succ), ote(Succ, E, Succ_), ote_sommet_rec(E, L, L_).


ote([X|L], X, L).
ote([Y|L], X, [Y, L_]) :- Y \= X, ote(L, X, L_).




tri_topologique(G, []) :- graphevide(G).
tri_topologique(G, O) :- \+graphevide(G), predecesseurs(S, G, []), ote_sommet(S, G, G_), tri_topologique(G_, O_), O = [S|O_].



%graphevide2(graphe([], [])).


%predecesseurs2(E, graphe(S, A), Pred) :- suppr_sommets(E, S), suppr_arcs(E, A).

%suppr_sommets(E, [E | L])

%1) CHEMIN/4
chemin(U, U, _G, [U]).
chemin(U, V, G, [U | L]) :- U \= V, successeurs(U, G, SuccU), chemin_rec(G, V, SuccU, L).

chemin_rec(G, V, [X | _Succ], [X | L]) :- chemin(X, V, G, [X | L]).
chemin_rec(G, V, [_X | Succ], L) :- chemin_rec(G, V, Succ, L).


%2) CYCLES/3
cycles(S, G, LC) :- successeurs(S, G, SuccS), cycles_rec(S, G, SuccS, LC).

cycles_rec(_S, _G, [], []).
cycles_rec(S, G, [X | SuccS], [C | LC]) :- chemin(X, S, G, C), cycles_rec(S, G, SuccS, LC).

%3) CYCLES/2
cycles_II(G, LC) :- sommets(G, Som), cycles_II_rec(G, Som, LC).%, flatten(LLC, LC).

cycles_II_rec(_G, [], []).
cycles_II_rec(G,  [X | Som], [C | LC]) :- cycles(X, G, C), cycles_II_rec(G, Som, LC).

%4) CFC/2
cfc(G,CFC):- sommets(G,Som), cfc_rec(G,Som,CFC).

cfc_rec(G,_,_)
cfc_rec(G,Som,CFC) :-
