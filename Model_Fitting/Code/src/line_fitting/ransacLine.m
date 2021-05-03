function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    
    rnd_idx= randperm(num_pts);
    p1 = [ data(1,rnd_idx(1)), data(2,rnd_idx(1)) ];
    p2 = [ data(1,rnd_idx(2)), data(2,rnd_idx(2)) ];
    
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    
    if(p1(1) == p2(1)) % vertical lines
        continue;
    end
    k = ( p1(2) - p2(2) )/ ( p1(1) - p2(1) );
    b = p1(2) - k*p1(1);
    
    
    % Compute the distances between all points with the fitting line
    
    d= k*data(1,:)-data(2,:)+ b;
    D=abs(d)/sqrt(k^2 + 1);
    
    % Compute the inliers with distances smaller than the threshold
    
    l=find(D<threshold);
    in_pts=data(:,l);
    in_num=length(l);
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    
    if ( in_num > best_num_inliers)
        best_k=k;
        best_b=b;
        best_num_inliers = in_num;
    end
    
    
    
    
    
end


end
