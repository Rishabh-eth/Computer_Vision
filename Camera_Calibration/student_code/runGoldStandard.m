%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

%denormalize projection matrix
Pmin_normalised = [pn(1:4);pn(5:8);pn(9:12)];
P=inv(T)*Pmin_normalised*U;

%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

%compute average reprojection error
a=vecnorm(xy-inhomogenization(P*homogenization(XYZ)));
error=mean(a);
end