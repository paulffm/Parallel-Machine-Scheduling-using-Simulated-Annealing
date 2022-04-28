function plotLowestCTatminimalCT(BestSol,solct,b,model)
%Falls mehrere Pläne, die gleiche minimale Zykluszeit/den minimalen
%Verbrauch haben, findet die Funktion den Plan mit den geringsten
%Kosten/geringster Zeit

if b==1
        
    deltaC=BestSol.Cost-solct.Cost;
    
    if deltaC>0
        
    figure(1);
    testPlot(solct,model);      
        
    figure(2);
    testPlotCost(solct,model);
    
    else
        
    figure(1);
    testPlot(BestSol,model);      
        
    figure(2);
    testPlotCost(BestSol,model);
    end
    

    elseif b==0  
    
    deltaT=BestSol.Time-solct.Time;
    
    if deltaT>0
        
    figure(1);
    testPlot(solct,model);      
        
    figure(2);
    testPlotCost(solct,model);
    
   
    else
    
        
    figure(1);
    testPlot(BestSol,model);      
        
    figure(2);
    testPlotCost(BestSol,model);
    end

 
   
    
end



