% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X,K)

% min and max values of each dimension
lmin=double(min(X(:,1)));
lmax=double(max(X(:,1)));
amin=double(min(X(:,2)));
amax=double(max(X(:,2)));
bmin=double(min(X(:,3)));
bmax=double(max(X(:,3)));
% uniformly spaced
l = linspace(lmin,lmax,K);
a= linspace(amin,amax,K);
b= linspace(bmin,bmax,K);
mu= [l;a;b];

end