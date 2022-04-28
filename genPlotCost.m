function genPlotCost(sol,model)
%Plottet den Energieverbrauch

    n=model.n; %number of Jobs I
    m=model.m; %number of machines J
   
    
    costsum=sol.costsum;
    alloc=sol.alloc;
    
    H=1;
    h=0.75;
    
    Colors=hsv(n);
    
    %Berechnung der Größe der Rechtecke für jeden Auftrag
    for j=1:m 
        y1=(j-1)*H;
        y2=y1+h;
        
        for k=1:length(alloc{j})
            
            if k==1
            x1=0;
            x2=costsum(alloc{j}(k));
            else
                x1=costsum(alloc{j}(k-1));
                x2=costsum(alloc{j}(k));
            end
            X=[x1 x2 x2 x1];
            Y=[y1 y1 y2 y2];
            
            %Farben
            C=Colors(alloc{j}(k),:);
            C=(C+[1 1 1])/2;
            
            fill(X,Y,C);
            hold on;
            
            %Beschriftung Jobs in der Mitte
            xm=(x1+x2)/2;
            ym=(y1+y2)/2;
            text(xm,ym,num2str(alloc{j}(k)),...
                'FontWeight','bold',...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle');
            set(gca,'YTickLabel',{}) %Y-Achse wird ausgeschaltet
        end
    end
    
 Cmmax=zeros(1,m);  
     
 for u=1:m
  Cmmax(u)=costsum(alloc{u}(length(alloc{u})));
     
     %Beschriftung Energieverbrauch pro Maschine
    plot([Cmmax(u) Cmmax(u)],[(u-1)*H u*H],'r:','LineWidth',2);
    text(Cmmax(u),u*H,['E' num2str(u) ' = ' num2str(Cmmax(u)) ' ' ],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','red');  
    
    %Maschinenbeschriftung
    text(0,(u-1)+h,['Maschine ' num2str(u) '   '],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','black');  
    
    grid on;
    hold on;
    
 end  
 
  %Beschriftung maximaler Energiekonsum
    Cges=sum(Cmmax);
    [Cmax]=sort(Cmmax); %rein für Beschriftung
 text(Cmax(m)*(1+1/8),m,['E_{ges} = ' num2str(Cges) '  '],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','red');  

hold off;
disp(['Energieverbrauch = ' num2str(Cges)]);

end

