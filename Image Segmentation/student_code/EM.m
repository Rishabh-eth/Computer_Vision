function [map cluster] = EM(img)

K=3; % number of segments
X=reshape(img,[],3);
X=double(X);
iter=0; % number of iterations
threshold=1e-3; % convergence of log-likelihood
log_lik=[];
resp=[]; % assignment of pixel to components

% Initialize alpha
alpha=repmat(1/K,1,K);
% use function generate_mu to initialize mus
mu=generate_mu(X,K);
% use function generate_cov to initialize covariances
sig=generate_cov(X,K);

% log_lik computation
N = size(X,1); %Number of points
d = size(X,2); %dimension of a point
P = zeros(N,K); %Probability in column k row j is the probability for point j to be in cluster k
for j = 1:N
    xl = double(X(j,:)'); 
    for k = 1:K
        p = alpha(k) * 1 / ((2*pi)^(d/2) * sqrt(det(double(sig{k,1})))) * exp(-0.5*(xl-mu(:,k))' * inv(double(sig{k,1})) * (xl-mu(:,k)));
        P(j,k) = p;
    end 
end
log_lik(iter+1)= sum(log(sum(P, 2)));

% iterate between maximization and expectation
% use function maximization
% use function expectation

while(true)
    iter = iter + 1;
    % E-step
    P = expectation(mu,sig,alpha,X);
    
    % M-step
    [mu_new, sig_new, alpha_new] = maximization(P, X);
    
    % log lik compute
    for j = 1:N
    xl = double(X(j,:)'); %X is Nx3, xl should be 3x1
    for k = 1:K
        p = alpha(k) * 1 / ((2*pi)^(d/2) * sqrt(det(double(sig_new{k,1})))) * exp(-0.5*(xl-mu_new(:,k))' * inv(double(sig_new{k,1})) * (xl-mu_new(:,k)));
        P(j,k) = p;
    end 
    end
    log_lik(iter+1)= sum(log(sum(P, 2)));

    resp=P; % unnormalised posterior probability of a point belonging to each component 
    cluster=mu_new';
    disp(log_lik(1,iter+1))
    % Convergence
    if(abs(log_lik(1,iter+1)-log_lik(1,iter))<threshold)
        break;
    end
    % update parameters
    mu=mu_new;
    sig=sig_new;
    alpha=alpha_new;

end

% Calculate pixel assignment
N = size(X,1);
s=size(img);
map=[];
for i=1:N
    c=resp(i,:);
    a=find(c==max(c));  % component with max posterior
    map=[map ;a(1)];
end

[rw,cl,~]=size(img);
map=reshape(map,rw,cl);


end