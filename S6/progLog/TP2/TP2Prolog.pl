%1)
vin1(100,"Chablis",1974,12).
vin1(110,"Mercurey",1978,13).
vin1(120,"Macon",1977,12).

vin2(100,"Chablis",1974,12).
vin2(200,"Sancerre",1979,11).
vin2(210,"Pouilly",1980,12).
vin2(230,"Pouilly",1981,12).

viticulteur("Nicolas","Pouilly","Bourgogne").
viticulteur("Martin","Bordaux","Bordelais").

%2)
%vin2(X,"Pouilly",_,_).
%vin2(X,_,_,12).

%3)
vin3(N,C,M,D):-vin1(N,C,M,D),vin2(N,C,M,D).

%4)
vin4(N,C,M,D):-vin1(N,C,M,D);vin2(N,C,M,D).

%vin4(X,_,_,12).

%5)
% \+(vin2(_,_,1978,_)).

%6)
vin5(N,C,M,D):-vin1(N,C,M,D),\+vin2(N,C,M,D).

%7)
vignoble(N,C,M,D,P,V,R):-vin5(N,C,M,D),viticulteur(P,V,R).

%8)
vin6(C,M):-vin5(_,C,M,_).

%9)
vin7(N,C,M,D):-vin4(N,C,M,D),(M>1975),(M<1980).

%10)
vin8(N,C,M,D,P,V,R):-vin4(N,C,M,D),viticulteur(P,V,R),(C=V).

%11)
:- ["vin9.pl"].
:- ["type.pl"].

% essai : cru(C):-(vin9(C),\+(((vin9(C),type(M,D)),\+vin9(C,M,D))(C))).

%correction
pv9(C):-vin9(C,_,_).
pv9xtype(C,M,D):-pv9(C),type(M,D).
reste(C,M,D):-pv9xtype(C,M,D),\+vin9(C,M,D).
cru(C):-pv9(C),\+reste(C,_,_).
