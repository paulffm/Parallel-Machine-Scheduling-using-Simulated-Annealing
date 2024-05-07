function genPlotTime(sol,model)
%Plotte Gantt-Diagramm

    n=model.n; %number of Jobs I
    m=model.m; %number of machines J
   
    
   
    
    fj=sol.timestruct.fj;
    vt=sol.timestruct.vt;
    alloc=sol.alloc;
    
    H=1;
    h=0.75;
    
    Colors=hsv(n);
    
    %Größe Rechtecke
    for j=1:m 
        y1=(j-1)*H;
        y2=y1+h;
        
        for k=1:length(alloc{j})
         
                
            x1=vt(alloc{j}(k)); %weiss: setuptime, idle time
            x2=fj(alloc{j}(k)); %farbig: process, nachlaufzeit
            
            
            X=[x1 x2 x2 x1];
            Y=[y1 y1 y2 y2];
            %Farben
            C=Colors(alloc{j}(k),:);
            C=(C+[1 1 1])/2;
            
            fill(X,Y,C);
            hold on;
            
            %Beschriftung Rechtecke
            xm=(x1+x2)/2;
            ym=(y1+y2)/2;
            text(xm,ym,num2str(alloc{j}(k)),...
                'FontWeight','bold',...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle');
            set(gca,'YTickLabel',{})
        end
    end
    
    %Beschriftung Maschinen
    for u=1:m
         text(0,(u-1)+h,['Maschine ' num2str(u) '   '],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','black');  
    
    grid on;
    hold on;
    
     end    
    
    
    Tmin=sol.Time;
    plot([Tmin Tmin],[0 m*H],'r:','LineWidth',2);
    text(Tmin,m*H,['Z = ' num2str(Tmin) ' '],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','red');
    
    grid on;
    
    hold off;
    disp(['Zykluszeit = ' num2str(Tmin)]);

end