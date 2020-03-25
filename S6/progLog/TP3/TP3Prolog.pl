%1)
homme("François Ier").
homme("Henri II").
homme("François II").
homme("Charles IX").
homme("Henri III").
homme("Charles Emmanuel").
homme("Victor-Amedee").
femme("Madeleine").
femme("Elisabeth").
femme("Margot").
femme("Marguerite").

parent("Charles IX","Elisabeth").
parent("Henri II","François II").
parent("Henri II","Charles IX").
parent("Henri II","Henri III").
parent("Henri II","Margot").
parent("François Ier","Henri II").
parent("François Ier","Madeleine").
parent("François Ier","Margot").
parent("Margot","Charles Emmanuel").
parent("Charles Emmanuel","Victor-Amedee").

%2)
pere(X,Y):-parent(X,Y),homme(X).
mere(X,Y):-parent(X,Y),femme(X).

%3)
fille(X,Y):-parent(X,Y),femme(Y).

%4)
gdparent(X,Y):-parent(X,T),parent(T,Y).

%5)
gdpere(X,Y):-grparent(X,Y),homme(X).
grmere(X,Y):-gdparent(X,Y),femme(X).

%6)
ancetre(X,Y):-parent(X,Y).
ancetre(X,Y):-parent(X,T),ancetre(T,Y).

%7)
frere(X,Y):-parent(T,X),parent(T,Y),homme(X),\+(X=Y).
soeur(X,Y):-parent(T,X),parent(T,Y),femme(X),\+(X=Y).

%8)
oncle(X,Y):-parent(T,Y),frere(X,T).
tante(X,Y):-parent(T,Y),soeur(X,T).

%9)
cousins_1(X,Y):-(oncle(X,T),pere(T,Y));(tante(X,T),mere(T,Y)).

%10)
%cousins_2(X,Y):-
