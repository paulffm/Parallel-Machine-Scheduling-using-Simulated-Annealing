function [BestSol,BestTime,BestCost,BestSchedule,BestOrder] = simulatedannealing(sol,MaxIt,MaxIt2,T,alpha,model,b)

n=model.n;



BestMixTC=zeros(MaxIt,1);
BestCost=zeros(MaxIt,1);
BestTime=zeros(MaxIt,1);
BestSchedule=zeros(MaxIt,n);
BestOrder=zeros(MaxIt,n);

%BestTime,BestCost,BestSchedule,
BestSol=sol;

for it=1:MaxIt
      for it2=1:MaxIt2
        
        % Erzeuge neue Lösung
        [solnew.schedule,solnew.order]=genNeighbor(sol.schedule,sol.order,model); 
        
        %Berechne Zielfunktionswert
        [solnew]=calcTarget(solnew,model,b); 
        
            if solnew.TimeandCost <= sol.TimeandCost 

            sol=solnew;
            
            else 
         
            delta=solnew.TimeandCost - (sol.TimeandCost);
            p=exp(-delta/T);
            
            if rand<=p
                sol=solnew;
            end
            end
            
        % Update beste Lösung
            if (sol.TimeandCost) <= (BestSol.TimeandCost)
            BestSol=sol;
            end
            
      end
        
    %Kosten und Energie speichern 
  
    BestCost(it)=BestSol.Cost;
    BestTime(it)=BestSol.Time;
    BestMixTC(it)=BestSol.TimeandCost;
    
    %Schedule und Reihenfolge speichern
    for i=1:n
    BestSchedule(it,i)=BestSol.schedule(i); 
    BestOrder(it,i)=BestSol.order(i);
    end
    
    %Temperatur reduzieren
    T=T*alpha; 
    

        BestMixTC(it)=BestSol.TimeandCost;
        disp(['Iteration ' num2str(it) ': Minimal Time = ' num2str(BestTime(it)) ': Minimal Energy = ' num2str(BestCost(it)) ': Minimal both =' num2str(BestMixTC(it)) ]);
end
disp(['Der Maschinenbelegungsplan hat folgende Zielfunktionswerte:' ]);
end

