function [w_x,w_y,E] = tps_model(X,Y,lambda)

% Number of sample points
N=size(X,1);

% compute distances between source points
r2=dist2(X,X);

% Matrices for linear system of equations
K=r2.*log(r2+eye(N,N));
P=[ones(N,1) X];
L=[K  P
   P' zeros(3,3)];
V=[Y' zeros(2,3)];

% regularization
L(1:N,1:N)=L(1:N,1:N)+lambda*eye(N,N);

% solution matrix 
c=L\V'; 

% column vectors to return 
w_x=c(:,1);
w_y=c(:,2);

% Bending energy
Ex=c(1:N,1)'*K*c(1:N,1);
Ey=c(1:N,2)'*K*c(1:N,2);
Ev=[Ex,Ey];
E=mean(Ev);
