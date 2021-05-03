function acc= bow_classification(histograms,labels,vBoWPos,vBoWNeg, classifierFunction)
  % function to calculate the accuracies for multiple iterations
   image_count = size(histograms,1) 
   pos = 0;
   neg = 0;
    for i = 1:image_count
		% classify each histogram
        l = classifierFunction(histograms(i,:),vBoWPos,vBoWNeg);

        % compare the result to the respective label
        if (l == labels(i)) % positive
            pos = pos + 1;
        else %negative
            neg = neg + 1;
        end
    end
    acc=(pos/image_count)*100;
   
end