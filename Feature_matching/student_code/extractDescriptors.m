% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)

% filtering points close to image boundaries
[r,c]=size(img);
a=keypoints(1,:);

% heuristics: 10 pixels close to horizontal boundary
a1=find(10<a & a<c-10); 

% same heuristics for vertical boundary
b=keypoints(2,:);
b1=find(10<b & b<r-10); 

ab=intersect(a1,b1);

% keypoints satisfying both constraints
keypoints=[a(ab);b(ab)]; 

% extract discriptors

patch_size=9;
descriptors = extractPatches(img, keypoints, patch_size);

end