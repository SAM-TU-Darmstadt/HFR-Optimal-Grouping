clear
close
clc
%% Randbedingungen

%p=Anzahl Inputvariablen
%n1=Anzahl der Versuchswiederholungen
%n=Gruppengröße

p=256;
n=ceil(sqrt(p));
n2 = n*n;
n1=n+1;

wasHere = [];

V=zeros(n2-1,n2); % Matrix zur Speicherung verbrauchter Kombinationen
k=zeros(n,n,n1); % Gruppenmatrix
I=ones(n,n,n); % Matrix zur Speicherung der Positionen der Variabeln in der Vorherigen Gruppe


if isprime(n) && false
    for ii = 1:n
        for jj = 1:n
            for kk = 1:n
                k(jj,ii,kk) = mod((jj-1)*n+(ii-1)*((kk-1)*n+1),n*n)+1;
            end
            k(ii,jj,n+1) = ii+(jj-1)*n;
        end
    end
else
%% Startkofiguration erstellen
% erster Durchlauf
for i1=1:n
    k(i1,:,1)=((i1-1)*n+1):i1*n;
end
% zweiter Durchlauf
k(:,:,2)=transpose(k(:,:,1));
% Besetzen der V-Matrix mit "verbrauchten" Kombinationen
for i1=1:2
    for i2=1:n
        V_1=nchoosek( k(i2,:,i1) ,2);
        for i3=1:nchoosek(n,2)
            V(V_1(i3,1),V_1(i3,2))=1;
        end
    end
end
spy(V)

%Indizes
tmp=1:n;
I(:,:,1)=tmp'*ones(1,n);% Matrix zur Speicherung der Positionen der Variabeln in der vorherigen Gruppe
id=3; %Durchlauf
ign=1; % Gruppe neu
ig=1;%=ipn Gruppe alt, Position neu
tic
% Restliche Gruppen
w1=0;
Is = {};
Gs = {};
% maxx = id*n1*n+ig+ign*n;
while w1==0
    
    if ig > 1
        while check_I(I(:,ig,id-1),ign)
            I(ign,ig,id-1)=I(ign,ig,id-1)+1;
        end
        wasHere(1) = 1;
    else
        if I(ign,ig,id-1) ~= ign
            error('was???');
        end
    end
    %
    if I(ign,ig,id-1) > n % Bedingung für den Rücklauf, wenn I>n
        
        if ig > 2 % Position zurück, wenn ig>1 ist können noch andere Variablen geprüft werden
            I(ign,ig,id-1)=1;
            ig=ig-1;
            I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            while check_I(I(:,ig,id-1),ign)
                I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            end
            wasHere(2) = 1;
        elseif ign==1 %durchlauf zurück
            
            I(ign,1,id-1)=1;
            I(ign,2,id-1)=1;
            id=id-1;
            if id<3
                error('id < 3 !!!!')
            end
            ig=n;
            ign=n;
            I(ign,ig,id-1)= 1; %gibt keine andere Möglichkeit mehr, muss auch Position zurück
            ig=ig-1;
            I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            while check_I(I(:,ig,id-1),ign)
                I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            end
            V = V_nullen(k(ign,:,id),V,n);
            wasHere(3) = 1;
            disp('Gruppe zurück');
        else %gruppe zurück
            I(ign,1,id-1)=1;
            I(ign,2,id-1)=1;
            ign=ign-1;
            ig=n;
            I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            while check_I(I(:,ig,id-1),ign)
                I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            end
            V = V_nullen(k(ign,:,id),V,n);
            wasHere(4) = 1;
        end
    end
    
    w2=0;% w2=0 wenn die Kombination nicht vorhanden ist
    % w2=1 wenn die Kombination vorhanden ist
    
    if I(ign,ig,id-1)<=n % Vorwärtszweig
        
        if ig==1 % erster Gruppeneintrag
            k(ign,ig,id)=k(ig,I(ign,ig,id-1),id-1);
            ig=ig+1;
            while check_I(I(:,ig,id-1),ign)
                I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            end
            wasHere(5) = 1;
        end
        
        
        k(ign,ig,id)=k(ig,I(ign,ig,id-1),id-1);%zu überprüfender G-Eintrag, in der neuen Gruppe
        
        %v=nchoosek(G(ign,1:ig,id),2);
        v = [k(ign,ig,id)*ones(ig-1,1),k(ign,1:ig-1,id)'];
        vsize=ig-1;%size(v);
        for i=1:vsize
            if v(i,1)>v(i,2)% 2er-Kombis der Größe nach sortieren
                vt1=v(i,1);
                v(i,1)=v(i,2);
                v(i,2)=vt1;
            end
            % Überprüfung ob eine der 2er-Kombis vorhanden ist, falls ja
            % w2=1
            if V(v(i,1),v(i,2))==1
                w2=1;
                break;
            end
        end
        
        if w2==1 % Kombination vorhanden, nächste Variable prüfen I+1
            I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            while check_I(I(:,ig,id-1),ign)
                I(ign,ig,id-1)=I(ign,ig,id-1)+1;
            end
            wasHere(6) = 1;
        elseif w2==0 %Kombination nicht vorhanden, nächste Position in der Gruppe
            if ig<n %nächste Position
                ig=ig+1;
            wasHere(7) = 1;
            elseif ign==n && id==n1 && ig==n %Ende
                %Erweiterung für alle Lösungen
                Is{end+1} = I;
                Gs{end+1} = k;
                I(ign,ig,id-1) = n+1;
                disp('Lösung gefunden');
                toc;
                w1=1;
                for ii=1:vsize(1)% V-Update
                    V(v(ii,1),v(ii,2))=1;
                end
            wasHere(8) = 1;
            elseif ign==n && ig==n %nächster Durchlauf
                ign=1;
                ig=1;
                id=id+1;
                
                for ii=1:vsize(1)% V-Update, eintragen der neuen Gruppe
                    V(v(ii,1),v(ii,2))=1;
                end
            wasHere(9) = 1;
            elseif ig==n %nächste Gruppe
                ig=1;
                ign=ign+1;
                
                for ii=1:vsize(1)% % V-Update, eintragen der neuen Gruppe
                    V(v(ii,1),v(ii,2))=1;
                end
                I(ign,ig,id-1) = ign;
            wasHere(10) = 1;
            end
        end
        
    end
end
end
disp('Fertig');
toc;
wasHere(11) = 1
%% test


    V_test=[];
    for i1=1:n
        for i2=1:n
            a=k(i2,:,i1);
            VV=nchoosek(a,2);
            V_test=[V_test; VV];
        end
    end
    out = true;
    
    Vsize=size(V_test);
    for ii=1:Vsize(1)
        if V_test(ii,1)>V_test(ii,2)% 2er-Kombis der Größe nach sortieren
            vt1=V_test(ii,1);
            V_test(ii,1)=V_test(ii,2);
            V_test(ii,2)=vt1;
        end
    end
    
    while ~isempty(V_test) && out
        
        V_T(1,:)=V_test(1,:);
        V_test(1,:)=[];
        Vsize=size(V_test);
        for ii=1:Vsize(1)
            if V_T==V_test(ii,:)
                %error(['Fehler! Doppelter Eintrag' num2str(V_T(1)) ' ' num2str(V_T(2))])
                out = false;
                break;
            end
        end
    end
    if ~out
        disp(['Nicht bei ' num2str(n)]);
    end


