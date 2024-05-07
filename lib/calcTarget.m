function [sol]= calcTarget(sol,model,b) %sol

%info
%endt=model.endtermin;
m=model.m;
n=model.n;           
order=sol.order;
schedule=sol.schedule;

%Zeiten
processtime=model.processtime;
nachlaufzeit=model.nachlaufzeit;
freigabetermin=model.freigabetermin;
setuptime=model.setuptime;

%Verbräuche je Maschinenzustand
costpt=model.costpt;        %Fertigungsverbrauch 
costnt=model.costnt;        %Verbrauch während Nachlaufzeit
costidle=model.costidle;    %Verbrauch während Wartezeit
costsetup=model.costsetup;  %Verbrauch während Umrüstung

pt=zeros(n,1);              %Fertigungszeit je Job 
nj=zeros(n,1);              %Nachlaufzeit je Job 
deltaf=zeros(n,1);          %Unterscheid Releastermin und Fertigstellungstermin
fj=zeros(n,1);              %Fertigstellungstermin je Job
st=zeros(n,1);              %Rüstzeit je Job
vt=zeros(n,1);              %Fertigungsbeginn je Job
times=zeros(m,1);           %Gesamtbearbeitungszeit auf Maschine
costs=zeros(n,1);           %Verbrauch je Job
costsum=zeros(n,1);         %Kummulierter Verbrauch (notwendig für Plot)

L=zeros(m,n);               %Zuweisungsmatrix
    for i=1:m
        for k=1:n
            if schedule(order(k))==i
                 L(i,k)=order(k);
            end
        end
    end
    
    alloc=cell(m,1);        %Joballokation auf Maschine
    for o=1:m
        alloc{o}=L(o,:);
        alloc{o}=alloc{o}(alloc{o}~=0);
    end


for l=1:m
    for j=1:length(alloc{l}) 
           
        pt(alloc{l}(j))=processtime(alloc{l}(j),l);
        nj(alloc{l}(j))=nachlaufzeit(alloc{l}(j),l);
        
        if freigabetermin(alloc{l}(j))>=times(l) 
           
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

        
        
        else %deltaf==0 
   
      
        if j==1 %erster Job auf Maschine l
            
        st(alloc{l}(j))=0;
        vt(alloc{l}(j))=st(alloc{l}(j)); %deltaf=st=0
        fj(alloc{l}(j))=pt(alloc{l}(j))+nj(alloc{l}(j));  
        costsum(alloc{l}(j))=processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)*0+st(alloc{l}(j))*costsetup(l);
       
        else
            
        st(alloc{l}(j))=setuptime(alloc{l}(j-1),alloc{l}(j),l);
        vt(alloc{l}(j))=st(alloc{l}(j))+fj(alloc{l}(j-1)); %deltaf->0
        fj(alloc{l}(j))=pt(alloc{l}(j))+nj(alloc{l}(j))+vt(alloc{l}(j));   
        costsum(alloc{l}(j))=costsum(alloc{l}(j-1))+processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+deltaf(alloc{l}(j))*costidle(l)+st(alloc{l}(j))*costsetup(l);
        
        end
        
        times(l) = times(l) + processtime(alloc{l}(j),l)+nachlaufzeit(alloc{l}(j),l)+st(alloc{l}(j));
        costs(alloc{l}(j))=processtime(alloc{l}(j),l)*costpt(l)+nachlaufzeit(alloc{l}(j),l)*costnt(l)+st(alloc{l}(j))*costsetup(l);
        end
  
    end 
    
end

       Cost=sum(costs);
       Tmin=max(times);
       
    
   
    timestruct.vt=vt;  
    timestruct.times=times;
    timestruct.pt=pt;
    timestruct.deltaf=deltaf;
    timestruct.nj=nj;
    timestruct.fj=fj;
    
sol.alloc=alloc;     
sol.TimeandCost=b*Tmin+(1-b)*Cost;  
sol.Cost=Cost;
sol.Auftragsverbrauch=costs;
sol.costsum=costsum;    
sol.Time=Tmin;
sol.timestruct=timestruct;

end



