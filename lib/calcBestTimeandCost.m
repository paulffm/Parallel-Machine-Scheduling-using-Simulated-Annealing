function solct=calcBestTimeandCost(BestTime, BestCost,BestSchedule,BestOrder,b,MaxIt,model)
%Falls mehrere Pläne, die gleiche minimale Zykluszeit/den minimalen
%Verbrauch haben, findet die Funktion den Plan mit den geringsten
%Kosten/geringster Zeit

 m=model.m;
 n=model.n;
 alloc=cell(m,1); 
 BestT=0;
 BestC=0;
 
processtime=model.processtime;
nachlaufzeit=model.nachlaufzeit;
freigabetermin=model.freigabetermin;
setuptime=model.setuptime;

%cost
costpt=model.costpt;
costnt=model.costnt;
costidle=model.costidle;
costsetup=model.costsetup;

pt=zeros(n,1);     %processtime Job j
nj=zeros(n,1);     %nachlaufzeit
deltaf=zeros(n,1); %Unterscheid Releasedate und Fertigungszeit
fj=zeros(n,1);     %Gesamtdauer Job i
st=zeros(n,1);
vt=zeros(n,1);
times=zeros(m,1);  %Zeit auf Maschine
costs=zeros(n,1);  %Kosten pro Job
costsum=zeros(n,1); %Summation der Kosten auf einer Maschine (nur wichtig für Plot)

if b==1 %Minimierung nach Zeit->Finden geringster Kosten
 
   c=[]; 
   i=1;
   sorder=[];
    for s=1:MaxIt
        if BestTime(s)==BestTime(MaxIt)
           c(i)=BestCost(s);
           sorder(i)=s;
           i=i+1;
        end
    end
    [c,order]=sort(c);
    BestC=c(1);
    
    BestS=BestSchedule(sorder(order(1)),:);
    BestO=BestOrder(sorder(order(1)),:);
    
    BestT=BestTime(sorder(order(1)));
    
    L=zeros(m,n); %Zuweisungsmatrix
    for j=1:m
        for k=1:n
            if BestS(BestO(k))==j
                 L(j,k)=BestO(k);
            end
        end
    end
    
    %Joballokation auf Maschine
    for o=1:m
        alloc{o}=L(o,:);
        alloc{o}=alloc{o}(alloc{o}~=0);
    end
    
    
    
    
elseif b==0 %Minimierung nach Verbrauch-> Finden geringster Zykluszeit
   
   t=[]; 
   i=1;
   sorder=[];
    for s=1:MaxIt
        if BestCost(s)==BestCost(MaxIt)
           t(i)=BestTime(s);
           sorder(i)=s;
           i=i+1;
        end
    end
    [t,order]=sort(t);
    BestT=t(1);
    
    BestS=BestSchedule(sorder(order(1)),:);
    BestO=BestOrder(sorder(order(1)),:);
    BestC=BestCost(sorder(order(1)));
    
    L=zeros(m,n); %Zuweisungsmatrix
    for j=1:m
        for k=1:n
            if BestS(BestO(k))==j
                 L(j,k)=BestO(k);
            end
        end
    end
    
    %Joballokation auf Maschine
    for o=1:m
        alloc{o}=L(o,:);
        alloc{o}=alloc{o}(alloc{o}~=0);
    end
    
end

for l=1:m
    for j=1:length(alloc{l}) 
           
        pt(alloc{l}(j))=processtime(alloc{l}(j),l);
        nj(alloc{l}(j))=nachlaufzeit(alloc{l}(j),l);
        
        if freigabetermin(alloc{l}(j))>=times(l) %vorlauf
           
        deltaf(alloc{l}(j))=freigabetermin(alloc{l}(j))-times(l);
       
        if j==1 %erster Job j auf Maschine l
        
        st(alloc{l}(j))=0; 
        vt(alloc{l}(j))=deltaf(alloc{l}(j))+st(alloc{l}(j));
        fj(alloc{l}(j))=pt(alloc{l}(j))+nj(alloc{l}(j))+vt(alloc{l}(j));  
        costsum(alloc{l}(j))=processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)*0+st(alloc{l}(j))*costsetup(l);
        costs(alloc{l}(j))=costsum(alloc{l}(j));
        else
            
        st(alloc{l}(j))=setuptime(alloc{l}(j-1),alloc{l}(j),l);
        vt(alloc{l}(j))=deltaf(alloc{l}(j))+st(alloc{l}(j))+fj(alloc{l}(j-1));
        fj(alloc{l}(j))=pt(alloc{l}(j))+nj(alloc{l}(j))+vt(alloc{l}(j)); 
        costsum(alloc{l}(j))=costsum(alloc{l}(j-1))+processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)+st(alloc{l}(j))*costsetup(l);
        costs(alloc{l}(j))= processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)+st(alloc{l}(j))*costsetup(l);
        end
        
        times(l) = times(l) + processtime(alloc{l}(j),l)+nachlaufzeit(alloc{l}(j),l)+deltaf(alloc{l}(j))+st(alloc{l}(j));
       
        
        
        else %deltaf==0 -> kein Warten auf Freigabetermin
   
      
        if j==1 %erster Job auf Maschine l
            
        st(alloc{l}(j))=0;
        vt(alloc{l}(j))=st(alloc{l}(j)); %deltaf=st=0
        fj(alloc{l}(j))=pt(alloc{l}(j))+nj(alloc{l}(j));  
        costsum(alloc{l}(j))=processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)*0+st(alloc{l}(j))*costsetup(l);
       
        else
            
        st(alloc{l}(j))=setuptime(alloc{l}(j-1),alloc{l}(j),l);
        vt(alloc{l}(j))=st(alloc{l}(j))+fj(alloc{l}(j-1)); %deltaf->0
        fj(alloc{l}(j))=pt(alloc{l}(j))+nj(alloc{l}(j))+vt(alloc{l}(j));   
        costsum(alloc{l}(j))=costsum(alloc{l}(j-1))+processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)*0+st(alloc{l}(j))*costsetup(l);
        
        end
        
        times(l) = times(l) + processtime(alloc{l}(j),l)+nachlaufzeit(alloc{l}(j),l)+st(alloc{l}(j));
       costs(alloc{l}(j))=processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+st(alloc{l}(j))*costsetup(l);
        end
  
    end 
end 

    
    timestruct.vt=vt;  
    timestruct.times=times;
    timestruct.pt=pt;
    timestruct.deltaf=deltaf;
    timestruct.nj=nj;
    timestruct.fj=fj;
    
solct.schedule=BestS;
solct.order=BestO;
solct.alloc=alloc; 
solct.Cost=BestC;
solct.Auftragsverbrauch=costs;    
solct.costsum=costsum;
solct.Time=BestT;
solct.timestruct=timestruct; 



 

end

