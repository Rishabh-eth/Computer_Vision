load('dataset.mat')
display_flag=1;
X=objects(8).X;
Y=objects(10).X;

%% Sampling by min samples in each shape
% nx= size(X,1);
% ny=size(Y,1);
% if nx>ny
%     X_nsamp = get_samples(X,ny);
%     Y_nsamp = Y;
% else
%     if ny>nx
%         Y_nsamp = get_samples(Y,nx);
%         X_nsamp = X;
%     else
%         X_nsamp =X;
%         Y_nsamp=Y;
%     end
% end
%% Hard sampling
 X_nsamp = get_samples(X,100);
 Y_nsamp = get_samples(Y,100);
%% 

matchingCost = shape_matching(X_nsamp,Y_nsamp,display_flag);