function thresh = select_thresh(I)

% histogram of image
h = histogram(double(I),255);
v= h.Values;
% Differentiation of histogram
g=diff(v);
g(255)=0;
% sign check
g2=g;
g2(g2==0)=0;
g2(g2>0)=1;
g2(g2<0)=-1;
% peaks and valleys
g2_shift= [ g2(2:end) 0 ];
[~,N]=size(g2);
idx=[1:N];
mask1= g2>g2_shift;
peaks=idx(mask1);
mask2= g2<g2_shift;
vly=idx(mask2);
% mean valleys
h_vly=v(vly);
mean_vly=mean(h_vly);
scaled_h_vly=h_vly-mean_vly;

%diff_vly=g(vly).^2;
diff_vly=abs(g(vly));

D=abs(scaled_h_vly+diff_vly);
[~,ith]=min(D);
thresh=vly(ith);
close all
