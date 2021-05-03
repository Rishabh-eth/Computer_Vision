% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)

%data normalization
[~,N]= size(xs);

% 1. compute centroid
centroid= mean(xs,2);

% 2. shift the input points so that the centroid is at the origin
x_shifted=xs-centroid;

% 3. compute scale
x_scale=(1/N)*x_shifted*(x_shifted)';

% 4. create transformation matrices (similarity transformation)
[V,D]= eig(x_scale);
A=inv(V*sqrt(D));
b=-A*centroid;
T=[A,b;0,0,1];

% 5. normalize the points according to the transformations
xs_hom=[xs;ones(1,N)];
nxs=T*xs_hom;

end
