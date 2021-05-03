function hist = computeHOG(ang, mgn, nbins)
% Alternate method of computing HoG as stated in Dalal and Triggs
binSize = pi/nbins;
hist = zeros(1,nbins);

% same line for angle and angle + pi. This way we are between 0 and 180
ang(ang < 0) = ang(ang < 0) + pi;

% calculate centre points of each bin
min_ang=0;
max_ang=pi;
centre1=(binSize-min_ang)/2;
centre_bin=centre1:binSize:max_ang;

for i = 1:numel(ang)
    diffAngles = abs(centre_bin-ang(i));
    [minDiff,nearestInd] = min(diffAngles);
    if nearestInd==1
        hist(nearestInd) = hist(nearestInd) + mgn(i);
    else
        if nearestInd==8
            hist(nearestInd) = hist(nearestInd) + mgn(i);
        else
            minDiff2 = min(diffAngles(diffAngles>minDiff));
            nearestInd2 = find(diffAngles == minDiff2,1);
            hist(nearestInd) = hist(nearestInd) + mgn(i) * (binSize-minDiff)/binSize;
            hist(nearestInd2) = hist(nearestInd2) + mgn(i) * (binSize-minDiff2)/binSize;
        end
    end
    
end
hist=hist/sum(hist);
end