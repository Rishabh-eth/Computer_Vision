% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

% Compute gradient in x and y direction

Ix = conv2(img,0.5*[1 , 0,-1], 'same');
Iy = conv2(img,0.5*[1 ;0; -1], 'same');

% Elements of the local autocorrelation matrix
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

% Gaussian weighting of elements of local autocorrelation matrix
Ix2g=imgaussfilt(Ix2,sigma);
Iy2g=imgaussfilt(Iy2,sigma);
Ixyg=imgaussfilt(Ixy,sigma);

% Calculation of Harris Response function C
% (A+B) is the determinant and sqrt(D) is the trace
% of the autocorrelation matrix at each pixel
A= Ix2g.*Iy2g;
B = Ixyg.^2;
D= (Ix2g+Iy2g).^2;
C= (A-B)-k*D;

% Non-maximal supression
con1= imregionalmax(C);
% Harris response function value strength
con2=C>thresh;
% Select points satisfying both condition
con=con1&con2;

[r,w]=find(con);
corners=[r,w]';

end