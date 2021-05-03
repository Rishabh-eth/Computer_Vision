function [map peak] = meanshiftSeg(img)
X=reshape(img,[],3); % convert to discrete samples of density function
X=double(X);
r=20; % hyperparameter; radius
[N,~]=size(X); % number of points
modes=[]; % modes of the density function
member=zeros(1,N); % stores the assignment of pixel to mode
count=0;
for i=1:N 
    p=find_peak(X, X(i,:) , r);
    if(i==1) % first mode
        modes=[modes;p];
        count=count+1;
        member(i)=count;
    else 
        d=pdist2(modes,p,'euclidean'); % distance between current peak and existing modes
        if(any(d<r/2))
            x=find(d<r/2); % modes with distance less than r/2 to the peak
            [nx,~]=size(x);
            if(nx>1)       % multiple modes with distance lesser than r/2
                mx=min(d);
                x=find(d==mx); % choose mode with min distance
                x=x(1,1);
            end
            z=[modes(x,:);p];
            
            modes(x,:)=mean(z); % replace the mode and the current peak with their mean
            member(i)=x;
        else
            modes=[modes;p]; % new mode
            count=count+1;
            member(i)=count;
        end
    end
    
end
[rw,cl,~]=size(img);
map=reshape(member,rw,cl); % reshape to image dimension
peak=modes; % final modes after convergence

end

