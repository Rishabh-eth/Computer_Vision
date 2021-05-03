function diffs = diffsGC(img1, img2, dispRange)

% get data costs for graph cut
w_radius=3;
kernel = fspecial('average',w_radius);

  % conver to double/single
   I1 = img1;
   I2 = img2;

  % the range of disparity values from min_d to max_d inclusive
  d_vals = dispRange;
  num_d = length(d_vals);
  C = NaN(size(I1,1), size(I1,2), num_d); % the cost volume

  % the main loop
  for i = 1 : length(d_vals)
    d = d_vals(i);
    I2_s = shiftImage(I2,d);
    imdf = (I1-I2_s).^2; 
    C(:,:,i) = conv2(imdf, kernel,'same');

  end

  
  diffs=C;

end