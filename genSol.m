function [sol]= genSol(model)
%Startlösung

n=model.n;
m=model.m;
schedule=randi(m,1,n);
order=randperm(n);

L=zeros(m,n); %Zuweisungsmatrix
    for i=1:m
        for k=1:n
            if schedule(order(k))==i
                 L(i,k)=order(k);
            end
        end
    end
    
    alloc=cell(m,1); %Joballokation auf Maschine
    for o=1:m
        alloc{o}=L(o,:);
        alloc{o}=alloc{o}(alloc{o}~=0);
    end

sol.alloc=alloc;    
sol.schedule=schedule; %schedule,order für testNeigh
sol.order=order;
end