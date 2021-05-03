% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X, K)

lmin=min(X(:,1));
lmax=max(X(:,1));
amin=min(X(:,2));
amax=max(X(:,2));
bmin=min(X(:,3));
bmax=max(X(:,3));
% range of each dimension
lrange=lmax-lmin;
arange=amax-amin;
brange=bmax-bmin;
v=[lrange arange brange];
cov=cell(K,1);
for k=1:K
    cov{k,1}=diag(v); % diagonal initialisation
end

end