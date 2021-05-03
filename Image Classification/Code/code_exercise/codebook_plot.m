% script for calculating accuracies over different iterations and codebook
% size

cobk=10:50:500;
iter=5;
cb_nn=[];
cb_bs=[];
for i=1:size(cobk,2)
sizeCodebook = cobk(i);
nnac=[];
bac=[];
for j=1:iter
vCenters = create_codebook('C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/cv_lab10_categorization/cv_lab10_categorization/data3/flower-training-pos','C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/cv_lab10_categorization/cv_lab10_categorization/data3/flower-training-neg',sizeCodebook);


vBoWPos = create_bow_histograms('C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/cv_lab10_categorization/cv_lab10_categorization/data3/flower-training-pos',vCenters);

vBoWNeg = create_bow_histograms('C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/cv_lab10_categorization/cv_lab10_categorization/data3/flower-training-neg',vCenters);

vBoWPos_test = create_bow_histograms('C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/cv_lab10_categorization/cv_lab10_categorization/data3/flower-testing-pos',vCenters);

vBoWNeg_test = create_bow_histograms('C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/cv_lab10_categorization/cv_lab10_categorization/data3/flower-testing-neg',vCenters);

nrPos = size(vBoWPos_test,1);
nrNeg = size(vBoWNeg_test,1);
 
test_histograms = [vBoWPos_test;vBoWNeg_test];
labels = [ones(nrPos,1);zeros(nrNeg,1)];

x1=bow_classification(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
nnac=[nnac x1];
x2=bow_classification(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
bac=[bac x2];
end
cb_nn=[cb_nn mean(nnac)];
cb_bs=[cb_bs mean(bac)];
end
% figure
% plot(cobk, cb_nn)
% hold on
% plot(cobk, cb_bs)
% title('Accuracy variation with codebook size')
% xlabel('Codebook size') 
% ylabel('Classification accuracy')
% legend('K-NN','Bayes')
