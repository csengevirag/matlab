XA = dlmread("poisson.txt"); %beolvassa a fajlt
created = XA(1:end-1, 1); %matrix a szuletesi idokre
died = XA(1:end-1, 2); %matrix a halalozasi idokre
m=min(min(created),min(died)); %a legfiatalabb elem
cr=double(created-m); %kivonjuk a szuletesekbol a legfiatalabb elemet
di=double(died-m); %kivonjuk a halalozasokbol a legfiatalabb elemet, igy mar kisebb szamokat kapunk, amiket konnyebb kezelni
wt=di-cr; %waiting time, ennyit all sorban az adott message
mwt = mean(wt); %a sorbanallasi idok atlaga
wtvar = var(wt)/mean(wt)/mean(wt); %sorbanallasi idok szorasnegyzete
v=[cr,ones(length(cr),1); di,-1*ones(length(cr),1)]; % egymas utan fuzi a szuletesi es halalozasi idopontokat, az elobbi melle 1-et, az utobbi melle -1-et fuz
vs=sortrows(v,1); %az elso oszlopa szerint novekvo sorrendbe allitja az elozo matrixot
ql=cumsum(vs(:,2)); %a szuletesi es halalozasi idok alapjan novekvo sorendbe allitott matrix masodik oszlopat adja ossze ugy, hogy az aktualis erteket hozzaadja az eddig kiszamolt ertekhez
vs=[vs,ql]; %mostmar a vs a vs matrix es melle fuzve az elozo osszegzett szamokbol allo matrix
stairs(vs(2:end,1),vs(2:end,3)) %grafikon
meanvs = mean(vs(2:end,3)); %sulyozott atlag a masodik es harmadik oszlop szerint, sorbanallo message-ek szama?
vs=[vs,[diff(vs(:,1));0]]; %kiszamolja az elso oszlopban az elemek egymastol valo kulonbseget
mql=vs(2:end-1,3)'*vs(2:end-1,4)/sum(vs(2:end-1,4)); % az egymastol valo kulonbsegek a harmadik oszlop szerint sulyozva, elosztva a kulonbsegek osszegevel?
lambda=mql/mwt*1e6; %a beallitott lambda ertek ellenorzese
mql_vector=vs(2:end-1,3).*vs(2:end-1,4)/sum(vs(2:end-1,4)); % ?
Y = vs(:,3); %sorbanallo messagge-ek szama
S = Y./Y; %ennek az eredmenye egy olyan matrix, ahol a 0 sorbanallasoknal NaN erteku lesz a matrix adott sora
help2 = vs(:,2)-1; %a szuletesekbol 0 lesz, a halalozasokbol -2
help3 = S.*help2; %a halalozasok es a NaN-ok maradnak, tobbi 0
help3 = help3*-0.5; %a halalozasokbol 1 lesz, NaN-ok maradnak
help4 = help3.*vs(:,4); %sorbanallasi ido a halalozasokra
help4 = nonzeros(help4); %0/k kiszurese
help4(isnan(help4)) = []; %NaN-ok kiszurese
S = help4; %kiszolgalasi idok
ss = vs(vs(:,2)== -1 | (vs(:,2) == 1 & vs(:,3) == 1),:); %halálozási sorok és olyan születési sorok, ahol egy üzenet áll sorban
diffss = diff(ss(:,1)); %az ss első sorai közötti differencia
diffss = [diffss(:,1), ss(1:end-1,3)]; %a sorbanálló üzenetek számának hozzáfűzése
diffsszero = diffss(diffss(:,2) == 0,1); %a nulla sorbanálló üzenetes sorok kiszolgálási ideje
meandiffsszero = mean(diffsszero); %diffsszero átlaga
diffsszerocv2 = var(diffsszero)/mean(diffsszero)/mean(diffsszero); %szórásnégyzet
diffssnonzero = diffss(diffss(:,2) ~= 0,1); %a nem nulla sorbanálló üzenetes sorok kiszolgálási ideje
%sum(diffssnonzero > 2E9);
%diffssnonzero(diffssnonzero > 2E9) = [];
%sum(diffssnonzero < 0);
%min(diffssnonzero);
%sum(diffssnonzero == 2480);
meandiffssnonzero = mean(diffssnonzero); %átlag
%find(diffss(:,1) == 2480);
%find(vs(:,1) == [833876781889.000]);
%format short g
%vs(31500:31570,:);
%min(diff(di));
diffssnonzerocv2 = var(diffssnonzero)/mean(diffssnonzero)/mean(diffssnonzero); %corr számolása manuálisan
ro = lambda*mean(diffssnonzero)/1E6; %a képlethez ró kiszámolása
mean(diffssnonzero)*ro/(1-ro)*(1+diffssnonzerocv2)/2;
mean(diffssnonzero(1:end-1).*diffssnonzero(2:end));
(mean(diffssnonzero(1:end-1).*diffssnonzero(2:end)) - mean(diffssnonzero)*mean(diffssnonzero))/var(diffssnonzero);











