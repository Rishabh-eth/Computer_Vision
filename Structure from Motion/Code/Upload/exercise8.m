 % =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.000.pgm';
imgName2 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.004.pgm';

% threshold
thresh1=0.0001;
thresh2=0.05;

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
x1=fa(1:2, matches(1,:));
x2=fb(1:2, matches(2,:));

x1_hom=makehomogeneous(x1); % convert to homogenous coordinates
x2_hom=makehomogeneous(x2);

x1_calibrated= inv(K)*x1_hom; % convert to calibrated coordinates
x2_calibrated= inv(K)*x2_hom;

[E, inliers] = ransacfitfundmatrix(x1_calibrated, x2_calibrated, thresh1);
% inlier matches
showFeatureMatches(img1, x1(1:2, inliers), img2, x2(1:2, inliers), 21);
% outlier matches
Nm=size(matches,2);
showFeatureMatches(img1, x1(1:2, setdiff(1:Nm,inliers)), img2, x2(1:2, setdiff(1:Nm,inliers)), 22);

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated(1:2, inliers), x2_calibrated(1:2, inliers));
% fix to handle projection matrix with negative determinant
if (det(Ps{2}(1:3,1:3)) < 0 )
     Ps{2}(1:3,1:3) = -Ps{2}(1:3,1:3);
     Ps{2}(1:3, 4) = -Ps{2}(1:3, 4);
 end
%triangulate the inlier matches with the computed projection matrix
[XS, err] = linearTriangulation(Ps{1}, x1_calibrated(1:2, inliers), Ps{2}, x2_calibrated(1:2, inliers));

%% draw epipolar lines (optional)



[F, inliers_ab] = ransacfitfundmatrix(x1_hom, x2_hom, thresh1);
figure(1),clf, imshow(img1, []); hold on, plot(x1(1,inliers_ab), x1(2,inliers_ab), '*r');
figure(2),clf, imshow(img2, []); hold on, plot(x2(1,inliers_ab), x2(2,inliers_ab), '*r');
 [U,S,V] = svd(F)
 epipole1_hom = V(:,end)
 epipole_1 = epipole1_hom(1:2)/epipole1_hom(3) % epipoles calculation
 epipole2_hom = U(:,end)
 epipole_2 = epipole2_hom(1:2)/epipole2_hom(3)
  
 % draw epipolar lines in img 1
 figure(1)
fa_matched_inliers = x1(:,inliers_ab);
fb_matched_inliers = x2(:,inliers_ab);
%  
for k = 1:size(fb_matched_inliers,2)
    drawEpipolarLines(F'*makehomogeneous(fb_matched_inliers(:,k)), img1);
    drawnow; 
end
plot(epipole_1(1),epipole_1(2), 'g*')
drawnow;
% draw epipolar lines in img 2
figure(2)
for k = 1:size(fa_matched_inliers,2)
    drawEpipolarLines(F*makehomogeneous(fa_matched_inliers(:,k)), img2); 
end
plot(epipole_2(1),epipole_2(2), 'g*')
drawnow;


%% Add an addtional view of the scene 

imgName3 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
x1_new=x1_calibrated(:, inliers);
da_matched=da(:, matches(1,:));
da_tri=da_matched(:,inliers);
[matches, scores] = vl_ubcmatch(da_tri, dc);
%run 6-point ransac
x1_newmatch=x1_new(:, matches(1,:));
x3=fc(1:2, matches(2,:));
x3_hom=makehomogeneous(x3);
x3_calibrated= inv(K)*x3_hom;
X3=XS(:, matches(1,:));
[P, inliers] = ransacfitprojmatrix(x3_calibrated, X3, thresh2);
Ps{3} =P; 
if (det(Ps{3}(1:3,1:3)) < 0 )
     Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
     Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end
xa=K*x1_newmatch;
xb=K*x3_calibrated;
showFeatureMatches(img1, xa(1:2, inliers), img3, xb(1:2, inliers), 23);
Nm=size(matches,2);
showFeatureMatches(img1, xa(1:2, setdiff(1:Nm,inliers)), img3, xb(1:2, setdiff(1:Nm,inliers)), 24);
%triangulate the inlier matches with the computed projection matrix
[XS1, err] = linearTriangulation(Ps{1}, x1_newmatch(1:2, inliers), Ps{3}, x3_calibrated(1:2, inliers));
%% Add more views...

imgName4 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.001.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated
x1_new=x1_newmatch(:, inliers); 
da_matched=da_tri(:, matches(1,:));
da_tri=da_matched(:,inliers);
[matches, scores] = vl_ubcmatch(da_tri, dd);
%run 6-point ransac
x1_newmatch=x1_new(:, matches(1,:));
x4=fd(1:2, matches(2,:));
x4_hom=makehomogeneous(x4);
x4_calibrated= inv(K)*x4_hom;
X4=XS1(:, matches(1,:));
[P, inliers] = ransacfitprojmatrix(x4_calibrated, X4, thresh2);
Ps{4} =P; 
if (det(Ps{4}(1:3,1:3)) < 0 )
     Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
     Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end
xa=K*x1_newmatch;
xb=K*x4_calibrated;
showFeatureMatches(img1, xa(1:2, inliers), img4, xb(1:2, inliers), 25);
Nm=size(matches,2);
showFeatureMatches(img1, xa(1:2, setdiff(1:Nm,inliers)), img4, xb(1:2, setdiff(1:Nm,inliers)), 26);
%triangulate the inlier matches with the computed projection matrix
[XS2, err] = linearTriangulation(Ps{1}, x1_newmatch(1:2, inliers), Ps{4}, x4_calibrated(1:2, inliers));

%% Add more views

imgName5 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated
x1_new=x1_newmatch(:, inliers); 
da_matched=da_tri(:, matches(1,:));
da_tri=da_matched(:,inliers);
[matches, scores] = vl_ubcmatch(da_tri, de);
%run 6-point ransac
x1_newmatch=x1_new(:, matches(1,:));
x5=fe(1:2, matches(2,:));
x5_hom=makehomogeneous(x5);
x5_calibrated= inv(K)*x5_hom;
X5=XS2(:, matches(1,:));
[P, inliers] = ransacfitprojmatrix(x5_calibrated, X5, thresh2);
Ps{5} =P; 
if (det(Ps{5}(1:3,1:3)) < 0 )
     Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
     Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end
xa=K*x1_newmatch;
xb=K*x5_calibrated;
showFeatureMatches(img1, xa(1:2, inliers), img5, xb(1:2, inliers), 27);
Nm=size(matches,2);
showFeatureMatches(img1, xa(1:2, setdiff(1:Nm,inliers)), img5, xb(1:2, setdiff(1:Nm,inliers)), 28);
%triangulate the inlier matches with the computed projection matrix
[XS3, err] = linearTriangulation(Ps{1}, x1_newmatch(1:2, inliers), Ps{5}, x5_calibrated(1:2, inliers));

%% Plot stuff

fig = 10;
figure(fig);
XS_inhom=makeinhomogeneous(XS);
XS1_inhom=makeinhomogeneous(XS1);
XS2_inhom=makeinhomogeneous(XS2);
XS3_inhom=makeinhomogeneous(XS3);
%use plot3 to plot the triangulated 3D points
hold on
axis([0 2 0 5 0 2])
plot3(XS_inhom(1,:),XS_inhom(2,:),XS_inhom(3,:),'*','Color','r')
plot3(XS1_inhom(1,:),XS1_inhom(2,:),XS1_inhom(3,:),'*','Color','g');
plot3(XS2_inhom(1,:),XS2_inhom(2,:),XS2_inhom(3,:),'*','Color','b')
plot3(XS3_inhom(1,:),XS3_inhom(2,:),XS3_inhom(3,:),'*','Color','c');
%draw cameras

drawCameras(Ps, fig);
hold off
%% Dense Reconstruction

% img1
% img2
% Ps{1}
% Ps{2}
imgName1 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.000.pgm';
imgName2 = 'C:/Users/risha/Desktop/ETH/sem1/CV/Lab/codes/Upload/data/house.001.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

x1=fa(1:2, matches(1,:));
x2=fb(1:2, matches(2,:));
x1_hom=makehomogeneous(x1);
x2_hom=makehomogeneous(x2);

% Image rectification
[F, inliers] = ransacfitfundmatrix(x1_hom, x2_hom, 0.0001);
[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    rectifyImages(img1, img2, [x1_hom(1:2, inliers)', x2_hom(1:2,inliers)'], F);

se = strel('square', 15);
maskL = imerode(maskL, se);
maskR = imerode(maskR, se);

figure(2);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);

dispRange = -40:40;

% disparity map computation
dispStereoL = ...
    stereoDisparity(imgRectL, imgRectR, dispRange);
dispStereoR = ...
    stereoDisparity(imgRectR, imgRectL, dispRange);
 
% figure(1);
% subplot(121); imshow(dispStereoL, [dispRange(1) dispRange(end)]);
% subplot(122); imshow(dispStereoR, [dispRange(1) dispRange(end)]);

thresh = 8;

maskLRcheck = leftRightCheck(dispStereoL, dispStereoR, thresh);
maskRLcheck = leftRightCheck(dispStereoR, dispStereoL, thresh);

maskStereoL = double(maskL).*maskLRcheck;
maskStereoR = double(maskR).*maskRLcheck;

% subplot(121); imshow(maskStereoL);
% subplot(122); imshow(maskStereoR);

create3DModel_pgm(double(dispStereoL), imgRectL, 1)
