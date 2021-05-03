function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

% Prior
P_Pos=0.5;
P_Neg= 1-P_Pos;

% Log-Likelihood
N = size(histogram,2);
Loglik_pos=0;
Loglik_neg=0;

for i = 1:N
    vp= log(normpdf(histogram(i),muPos(i), sigmaPos(i))) ;
    if ~isnan(vp)
        Loglik_pos = Loglik_pos +vp;
    end
    
    vn= log(normpdf(histogram(i),muNeg(i), sigmaNeg(i))) ;
    if ~isnan(vn)
        Loglik_neg = Loglik_neg + vn;
    end
        
end

% Likelihood
Lik_Pos=exp(Loglik_pos);
Lik_Neg=exp(Loglik_neg);

% Evidence
%P_hist= Lik_Pos*P_Pos+Lik_Neg*P_Neg;

% Posterior
Post_pos=(Lik_Pos*P_Pos);
Post_neg=(Lik_Neg*P_Neg);

% Decision
if Post_pos > Post_neg
    label = 1;
else
    label = 0;
end

end