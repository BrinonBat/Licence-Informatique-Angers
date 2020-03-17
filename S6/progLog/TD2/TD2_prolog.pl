
%1)
rang_pair([_,Y|L1],[Y|L2]):- rang_pair(L1,L2).
rang_pair([],[]).
rang_pair([_],[]).

%2)
insertion([_|L1],X,[_|L2]):-insertion(L1,X,L2).
insertion(L,X,[X|L]).

%3)
membre(X,[_|L]):-membre(X,L).
membre(X,[X|_]).

%4)
prefixe([X|L],[X|LL_]) :- prefixe(L,LL_).
prefixe([],_).

%5)
suffixe(L_,[_X|LL_]) :- suffixe(L_,LL_).
suffixe(L,L).

%6) pas  corrigé
permute([X|L],[P|X]):- permute(L,P).
permute([],[]).
