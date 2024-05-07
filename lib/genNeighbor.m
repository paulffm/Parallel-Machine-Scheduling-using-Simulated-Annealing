function [qnew,ordernew]=genNeighbor(q,order,model)
m=model.m;
n=model.n;

q=randInsertion(q,m,n);
 
qnew=Swap(q);
ordernew=Swap(order);

   % y=randi([1 2]);
    
    %switch y
       %case 1
            % Do Swap
          %  qnew=Swap(q);
          % ordernew=Swap(order);
        %case 2
        %k=rand;
        % rand<k
            % Do Reversion
           % qnew=Reversion(q);
          %  ordernew=Reversion(order);
      %  case 3
            
          %  qnew=Insertion(q);
           % ordernew=Insertion(order);
       % end

end

function qnew=Swap(q) 

    n=numel(q); 
    
    i=randsample(n,2); 
    i1=i(1);
    i2=i(2);
    
    
    qnew=q;
    qnew([i1 i2])=q([i2 i1]);
    
end

function qnew=Reversion(q)

    n=numel(q);
    
    i=randsample(n,2);
    i1=min(i(1),i(2));
    i2=max(i(1),i(2));
    
    qnew=q;
    qnew(i1:i2)=q(i2:-1:i1); %im Elemnt von i1 bis i2 werden die Elemente von i2 bis i1 gespeichert

end

function qnew=Insertion(q)

    n=numel(q);
    
    i=randsample(n,2);
    i1=i(1);
    i2=i(2);
    
    if i1<i2
        qnew=[q(1:i1-1) q(i1+1:i2) q(i1) q(i2+1:end)];
    else
        qnew=[q(1:i2) q(i1) q(i2+1:i1-1) q(i1+1:end)];
    end
end

    function qnew=randInsertion(q,m,n)
        p=randi(m,1,2);
        for z=1:2
            
    qnew=q;
    qnew(randi(n))=p(z);
            
        end
    end


