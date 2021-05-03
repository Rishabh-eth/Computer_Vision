function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked
w_radius=41;
min_d=dispRange(1);

% aggregation filter (window size to aggerate the AD cost)
  kernel = fspecial('average',w_radius);

  % conver to double/single
  I1 = double(img1);
  I2 = double(img2);

  % the range of disparity values from min_d to max_d inclusive
  d_vals = dispRange;
  num_d = length(d_vals);
  C = NaN(size(I1,1), size(I1,2), num_d); % the cost volume

  % the main loop
  for i = 1 : length(d_vals)
    d = d_vals(i);
    I2_s = shiftImage(I2,d);
    imdf = (I1-I2_s).^2;%abs(I1 - I2_s); % you could also have SD here (I1-I2_s).^2
    C(:,:,i) = conv2(imdf, kernel,'same');

  end

  [~, D] = min(C, [], 3);
  disp = D + min_d;
end