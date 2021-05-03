function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
N = size(X,1);
D= size(X,2);
Nk=sum(P);
alpha=Nk/N;
X=double(X);
mu=[];
for k=1:K
    su=[];
    for i=1:N
         gk=P(i,k)*X(i,:);
         su=[su;gk];
    end
    uk=(1/Nk(1,k))*sum(su);
    mu=[mu uk']; % DXK matrix updating means
end

var=cell(K,1);
for k=1:K
    su=zeros(D);
    for i=1:N
         gk=P(i,k)*(X(i,:)-mu(:,k)')'*(X(i,:)-mu(:,k)'); % updating covariance matrices
         su=su+gk;
    end
    sigk=su/Nk(1,k);
    var{k,1}=sigk;
end



end