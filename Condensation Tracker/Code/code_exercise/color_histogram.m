function [ hist ] = color_histogram( xMin, yMin, xMax, yMax, frame, hist_bin )

    xMin = round(max(1,xMin));
    yMin = round(max(1,yMin));
    xMax = round(min(xMax,size(frame,2)));
    yMax = round(min(yMax,size(frame,1)));

    %Split into RGB Channels
    R = frame(yMin:yMax,xMin:xMax,1);
    G = frame(yMin:yMax,xMin:xMax,2);
    B = frame(yMin:yMax,xMin:xMax,3);

    %Get histValues for each channel
    [yR, ~] = imhist(R, hist_bin);
    [yG, ~] = imhist(G, hist_bin);
    [yB, ~] = imhist(B, hist_bin);

    hist = [yR; yG; yB];
    hist = hist/sum(hist);
    
    
end