conc([],L,L).
conc([X|L],L_,[X|LL_]):-conc(L,L_,LL_).

partage([],[],[]).
partage([X],[X],[]).
partage([X,Y|LL_],[X|L],[Y|L_]):-partage(LL_,L,L_).

inf_st(X,Y):-X<Y.

place(X,[Y|T],[X,Y|T]):-inf_st(X,Y).
place(X,[X|T],[X,X|T]).
place(X,[Y|T],[Y|TX]):-inf_st(Y,X),place(X,T,TX).

dpeda(_P[],[],[],[]).
dpeda(P,[X|L],PPP,[X[EP],PGP):-P=X,dpeda(P,L,PPP,EP,PGD).
dpeda(P,[X|L],PPP,EP,[X|PGP]):-inf_st(P,X),dpeda(P,L,PPP,EP,PGD).
dpeda(P,[X|L],[X|PPP],EP,PGP):-inf_st(X,P),dpeda(P,L,PPP,EP,PGD).

fusion([],[],[]).
fusion(T,[],T).
fusion([],T,T).
fusion([X|T],[Y|T_],[X|TT_]):-inf_st(X,Y),fusion(T,[Y,T_],TT_).
fusion([X|T],[Y|T_],[Y|TT_]):-inf_st(Y,X),fusion([X|T],T_,TT_).
fusion([X|T],[X|T_],[X,X|TT_]):-fusion(T,T_,TT_).
