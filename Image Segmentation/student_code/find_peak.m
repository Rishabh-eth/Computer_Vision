function peak = find_peak(X, xl , r)

pivot=xl; % current centre of circle
threshold=1; % threshold on distance between successive centres
while(1)
    D=pdist2(X,pivot,'euclidean');
    X1=X(D<r,:); % points within the cirlce
    new_pivot=mean(X1,1); % new centre
    if(norm(new_pivot-double(pivot))<threshold) % check convergence
        break;
    end
    pivot=new_pivot; %update centre of circle
    
end
peak=pivot;
end