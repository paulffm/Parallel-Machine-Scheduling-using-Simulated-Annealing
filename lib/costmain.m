%Zum Finden der Lösung eines Maschinenbelegungsproblems

%SA Parameter          
MaxIt=400;      % Maximum Number of Iterations
MaxIt2=80;      %epoch length

%Zielfunktion: Q= b*Z+(1-b)*E
 %Spezialfälle:
 %b=1 -> reine Minimierung nach Zykluszeit Z
 %b=0 -> reine Minimierung nach Energieverbrauch E

%Wahl der Startparameter

%Wahl von b
b=1;
 
%Temp
T0=105; 

% Kühlung
alpha=0.75; 

T=T0;

%Erzeuge Modell
model=genModel();
 
    %Generiere Startlösung
    [sol]=genSol(model); 

    %Berechne Zielfunktionswert

    [sol]=calcTarget(sol,model,b); 

    %Methode zum Finden der optimalen Lösung
    %SA 

    [BestSol,BestTime,BestCost,BestSchedule,BestOrder] = simulatedannealingB(sol,MaxIt,MaxIt2,T,alpha,model,b);
    
  
  if b==0 || b==1   
        
        [solct]=calcBestTimeandCost(BestTime,BestCost,BestSchedule,BestOrder,b,MaxIt,model);   
        plotLowestCTatminimalCT(BestSol,solct,b,model)
         
  %Plots der minimalen gemischten Zielfunktion       
  else
        %Plotte Zeit
        figure(1);
        genPlotTime(BestSol,model)
        
        %Plotte Verbrauch
        figure(2);
        genPlotCost(BestSol,model);
    
           
  end
    