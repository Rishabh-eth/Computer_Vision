function Xs = get_samples(X,n)

n1= size(X,1);
y = randsample(n1,n);
Xs= X(y,:);