% =========================================================================
% Feature extraction and matching
% =========================================================================
clear
addpath helpers

%don't forget to initialize VLFeat
run('C:/Users/risha/Downloads/vlfeat-0.9.21/toolbox/vl_setup')

%Load images
imgName1 = 'images/book1.JPG'; % Try with some different pairs
imgName2 = 'images/book2.JPG';
%  imgName1 = 'images/pumpkin1.JPG';
%  imgName2 = 'images/pumpkin2.JPG';
% imgName1 = 'images/rect1.JPG';
% imgName2 = 'images/rect2.JPG';
% imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
% imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];

%show matches
clf
showFeatureMatches(img1, x1s(1:2,:), img2, x2s(1:2,:), 1);


%%
% =========================================================================
% 8-point RANSAC
% =========================================================================

threshold = 5;

% TODO: implement ransac8pF
[inliers, ~] = ransac8pF(x1s, x2s, threshold);

showFeatureMatches(img1, x1s(1:2, inliers), img2, x2s(1:2, inliers), 1);

% =========================================================================
%% 

% Generate plots of threshold vs inlier count/ mean Sampson error

% th=[];
% inl=[];
% sam=[];
% for i=1:5:50
% % TODO: implement ransac8pF
% [inliers, F] = ransac8pF(x1s, x2s, i);
% inl=[inl sum(inliers)];
% S = distPointsLines(x2s(:,inliers), F*x1s(:,inliers)) + distPointsLines(x1s(:,inliers), F'*x2s(:,inliers));
% sam=[sam mean(S)];
% th=[th i];
% end
% figure
% plot(th,inl);
% xlabel('Threshold') 
% ylabel('Total inlier count') 
% 
% figure
% plot(th,sam);
% xlabel('Threshold') 
% ylabel('Mean Sampson distance of inliers ') 


%% 

% Generate plot for threshold vs number of trials in adaptive RANSAC

% th=[];
% inl=[];
% for i=1:5:50
% % TODO: implement ransac8pF
% [inliers, F,M] = ransac8pF(x1s, x2s, i);
% inl=[inl M];
% th=[th i];
% end
% figure
% plot(th(2:end),inl(2:end));
% xlabel('Threshold') 
% ylabel('Number of iterations for p=0.99') 

