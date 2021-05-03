function cost_mat = chi2_cost(histgm1,histgm2)

[nsamp1,~]=size(histgm1); % number of sample points and number of bins
[nsamp2,nbins]=size(histgm2);

s1=sum(histgm1,2); % sum of columns for each sample
s2=sum(histgm2,2);

histgm1_sum= repmat(s1+eps,[1 nbins]); % Repeat the sum value over all bins
histgm2_sum= repmat(s2+eps,[1 nbins]); % Add eps to handle divide by zero 

histgm1_norm=histgm1./histgm1_sum; % normalize histogram values across bins
histgm2_norm=histgm2./histgm2_sum;

cost_mat= zeros(nsamp1,nsamp2); % chi-square cost
for i=1:nsamp1
    x=histgm1_norm(i,:);
    x_rep=repmat(x,[nsamp2 1]);
    x_num= (x_rep-histgm2_norm).^2;
    x_denom= x_rep+histgm2_norm+eps;
    x_frac= x_num./x_denom;
    x_sum= sum(x_frac,2);
    cost_mat(i,:)=0.5*x_sum';
end