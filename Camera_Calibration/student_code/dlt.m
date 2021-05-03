%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% 1. For each correspondence xi <-> Xi, computes matrix Ai
[r,N]= size(XYZn);
A=[];
for i=1:N
    X=XYZn(:,i);
    x=xyn(1,i);
    y=xyn(2,i);
    z=[X',0,0,0,0,-(x)*(X)';0,0,0,0,X',-(y)*(X)'];
    A=vertcat(A,z);
end
% 2. Compute the Singular Value Decomposition of A

[~,~,V] = svd(A);

% 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
h=V(:,12);
P_normalized=[h(1:4)';h(5:8)';h(9:12)'];

end
