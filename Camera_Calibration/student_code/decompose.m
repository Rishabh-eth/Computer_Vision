%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

Ps= P(1:3,1:3);
Ps_inv=inv(Ps);

% Compute R, K with QR decomposition such M=K*R 

[Q,R1]= qr(Ps_inv);
R=inv(Q);
K=inv(R1);
% Compute camera center C=(cx,cy,cz) such P*C=0 
[~,~,V] = svd(P);
h=V(:,4);
alpha=1/h(4);
h1=alpha*h;
C=h1(1:3);
% normalize K such K(3,3)=1
beta=1/K(3,3);
K=beta*K;
% Adjust matrices R and Q so that the diagonal elements of K = intrinsic matrix are non-negative values and R = rotation matrix = orthogonal has det(R)=1

% Compute translation t=-R*C
t=-R*C;
end