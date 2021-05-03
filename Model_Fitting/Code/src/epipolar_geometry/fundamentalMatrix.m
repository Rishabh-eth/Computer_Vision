% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

% Get normalised points
[~,N]= size(x1s);
[x1_norm, T]= normalizePoints2d(x1s(1:2,:));
[x2_norm, U]= normalizePoints2d(x2s(1:2,:));

% Solving Af=0 
A=[x1_norm(1,:).*x2_norm(1,:); x1_norm(1,:).*x2_norm(2,:);x1_norm(1,:);x1_norm(2,:).*x2_norm(1,:);x1_norm(2,:).*x2_norm(2,:);x1_norm(2,:);x2_norm(1,:);x2_norm(2,:);ones(1,N)];
A=A';
[~,~,V] = svd(A);
f=reshape(V(:,end),3,3);

% singularity constraint
[uf,sf,vf] = svd(f);
fh = uf*diag([sf(1) sf(5) 0])*(vf');

% Rescaling the fundamental matrices
F= U'*f*T;
Fh=U'*fh*T;


end

