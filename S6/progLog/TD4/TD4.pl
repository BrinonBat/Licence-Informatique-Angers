est_vide(abvide).
racine(ab(X, _G, _D), X).
gauche(ab(_X, G, _D), G).
droit(ab(_X, _G, D), D).

nbnoeuds(abvide, 0).
nbnoeuds(ab(_, G, D), N) :-
     nbnoeuds(G, NG),
     nbnoeuds(D, ND),
     N is NG + ND + 1.

hauteur(abvide, 0).
hauteur(ab(_, G, D), H) :-
     hauteur(G, HG),
     hauteur(D, HD),
     H is maHG,HD) + 1.

parcours_prefixe(abvide, []).
parcours_prefixe(ab(X, G, D), [X | PGD]) :-
     parcours_prefixe(G, PG),
     parcours_prefixe(D, PD),
     append(PG, PD, PGD).

parcours_infixe(abvide, []).
parcours_infixe(ab(X, G, D), PGXD) :-
     parcours_infixe(G, PG),
     parcours_infixe(D, PD),
     append(PG, [X | PD], PGXD).

parcours_postfixe(abvide, []).
parcours_postfixe(ab(X, G, D), PGDX) :-
     parcours_postfixe(G, PG),
     parcours_postfixe(D, PD),
     append(PG, PD, PGD), append(PGD, [X], PGDX).


ajout(X, abvide, ab(X, abvide,abvide)).
ajout(X, A, A) :-
     A = ab(X,_,_).
ajout(X, ab(Y, G, D), ab(Y, G_, D)) :-
     X < Y,
     ajout(X, G, G_).
ajout(X, ab(Y, G, D), ab(Y, G, D_)) :-
     X > Y,
     ajout(X, D, D_).

ajoutliste([], A, A).
ajoutliste([X | L], A, XLA) :-
     ajout(X, A, XA),
     ajoutliste(L, XA, XLA).


appartient(X, ab(X, _G, _D)).
appartient(X, ab(Y, G, _D)) :-
     X < Y,
     appartient(X, G).
appartient(X, ab(Y, _G, D)) :-
     Y < X,
     appartient(X, D).


profondeur(X, ab(X, _G, _D), 0).
profondeur(X, ab(Y, G, _D), P) :-
     X < Y,
     profondeur(X, G, P_),
     P is P_ + 1.
profondeur(X, ab(Y, _G, D), P) :-
     Y < X,
     profondeur(X, D, P_),
     P is P_ + 1.

plus_grand(ab(X, _G, abvide), X).
plus_grand(ab(_X, _G, D), Y) :-
     plus_grand(D, Y).


supprime(X, ab(X, G, abvide), G).
supprime(X, ab(X, G, D), ab(Y, G_, D)) :-
     D = ab(_, _, _),
     plus_grand(G, Y),
     supprime(Y, G, G_). % Ici l'astuce est de réutiliser supprime pour
supprimer le plus grand du sous-arbre gauche et le remonter
supprime(X, ab(Y, G, D), ab(Y, G_, D)) :-
     X < Y,
     supprime(X, G, G_).
supprime(X, ab(Y, G, D), ab(Y, G, D_)) :-
     Y < X,
     supprime(X, D, D_).
