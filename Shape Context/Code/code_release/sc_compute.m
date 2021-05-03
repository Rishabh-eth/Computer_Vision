function [histogram,mean_dist] = sc_compute(X,tbin,rbin,rsmall,rbig)

npts = size(X,1); % number of sample points
ds=dist2(X,X);       % distance between pair of points
r_array=real(sqrt(ds)); 
y_diff=X(:,2)*ones(1,npts)-ones(npts,1)*X(:,2)'; % matrix of pairwise difference of y coordinates
x_diff=X(:,1)*ones(1,npts)-ones(npts,1)*X(:,1)'; % matrix of pairwise difference of x coordinates
arr_theta=atan2(y_diff,x_diff)'; % Angle between point pairs

mean_dist=mean(r_array(:)); % mean distance between point pairs

norm_r_array=r_array/mean_dist; % Normalization of distances

bin_r=logspace(log10(rsmall),log10(rbig),rbin); % radial distance bins
hist_r=zeros(npts,npts); % Initialise distance histogram
for i=1:rbin
   hist_r=hist_r+(norm_r_array<bin_r(i)); % iteratively add masks
end
in_bin_pts=hist_r>0; % remove points which did not fit in any bins

arr_t = rem(rem(arr_theta,2*pi)+2*pi,2*pi);
% quantize to a fixed set of angles (bin edges lie on 0,(2*pi)/k,...2*pi
one_bin=(2*pi/tbin);
qartheta = 1+floor(arr_t/one_bin);

histogram=zeros(npts,tbin*rbin);
for i=1:npts
   inpts=in_bin_pts(i,:); % points which lie within histogram distance range from ith point 
   Sn=sparse(qartheta(i,inpts),hist_r(i,inpts),1,tbin,rbin);
   histogram(i,:)=Sn(:)';
end


