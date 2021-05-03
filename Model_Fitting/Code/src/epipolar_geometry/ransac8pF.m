% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;
adpt=0; % Boolean value to use adaptive RANSAC
M=0; % Number of trials for p=0.99
for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    rnd_idx= randperm(num_pts);
    x1_8 = x1(:,rnd_idx(1:8));
    x2_8 = x2(:,rnd_idx(1:8));
    [Fh, ~] = fundamentalMatrix(x1_8, x2_8);
    
    % Compute the Sampson error.
    S = distPointsLines(x2, Fh*x1) + distPointsLines(x1, Fh'*x2);
    % Compute the inliers with errors smaller than the threshold.
    in_pts=S<threshold;
    in_num=length(find(S<threshold));
    
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    if ( in_num > best_num_inliers)
        best_num_inliers = in_num;
        best_inliers = in_pts;
        best_F = Fh;
    end
    
    % Check p=0.99 in case of adaptive RANSAC. 
    if (adpt==1)
        r=best_num_inliers/num_pts;
        p=1-((1-r^8))^i;
        disp(p)
        if(p>0.99)
            M=i
            break
        end
    end
end

end


