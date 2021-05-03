function P = expectation(mu,var,alpha,X)

K = length(alpha);
N = size(X,1); %Number of points
d = size(X,2); %dimension of a point
P = zeros(N,K); %Probability in column k row j is the probability for point j to be in cluster k
for j = 1:N
    xl = double(X(j,:)'); 
    for k = 1:K
        p = alpha(k) * 1 / ((2*pi)^(d/2) * sqrt(det(var{k,1}))) * exp(-0.5*(xl-mu(:,k))' * inv(var{k,1}) * (xl-mu(:,k)));
        P(j,k) = p;
    end
    Z = sum(P(j,:));
    
    P(j,:) = P(j,:) / Z; %Normalization
 
    
end

end