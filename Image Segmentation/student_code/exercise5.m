function run_ex5()

% load image
img = imread('cow.jpg');
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)
img = imresize(img, 0.4);

figure, imshow(img), title('original image')

% smooth image (6.1a)
% (replace the following line with your code for the smoothing of the image)
H = fspecial('gaussian',5);
imgSmoothed = imfilter(img,H); 
%imgSmoothed = imgaussfilt(img,5);
figure, imshow(imgSmoothed), title('smoothed image')

% convert to L*a*b* image (6.1b)
% (replace the folliwing line with your code to convert the image to lab
% space
cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed,cform);
figure, imshow(imglab), title('l*a*b* image')

% (6.2)
[mapMS peak] = meanshiftSeg(imglab);
visualizeSegmentationResults (mapMS,peak);

% (6.3)
[mapEM cluster] = EM(imglab);
visualizeSegmentationResults (mapEM,cluster);

end