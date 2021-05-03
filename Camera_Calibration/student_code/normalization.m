%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

[~,N]= size(XYZ);
% 1. compute centroid

xy_centroid= mean(xy,2);
XYZ_centroid= mean(XYZ,2);

% 2. shift the input points so that the centroid is at the origin

xy_shifted=xy-xy_centroid;
XYZ_shifted=XYZ-XYZ_centroid;

% 3. compute scale

xy_scale=(1/N)*xy_shifted*(xy_shifted)';
XYZ_scale=(1/N)*XYZ_shifted*(XYZ_shifted)';


% 4. create T and U transformation matrices (similarity transformation)
[V,D]= eig(xy_scale);
A=inv(V*sqrt(D));
b=-A*xy_centroid;
T=[A,b;0,0,1];

[V,D]= eig(XYZ_scale);
A=inv(V*sqrt(D));
b=-A*XYZ_centroid;
U=[A,b;0,0,0,1];


% 5. normalize the points according to the transformations
hom_xy=homogenization(xy);
hom_XYZ=homogenization(XYZ);
xy_normalized=T*hom_xy;
XYZ_normalized=U*hom_XYZ;

end