function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x));
    Gmag = sqrt(grad_y.^2 + grad_x.^2);
    
    for i = [1:size(vPoints,1)] % for all local feature points
        
        patch_cell_1 = vPoints(i,:)-[int32(nCellsW/2*w), int32(nCellsH/2*h)];
        
        patch = img(patch_cell_1(2):patch_cell_1(2)+ph -1,patch_cell_1(1):patch_cell_1(1)+pw -1);
        patches(i,:) = patch(:);
        for j = 1:nCellsW
            cell_pixel_1x = patch_cell_1(1) + (j-1)*w;
            for k = 1:nCellsH
                cell_pixel_1y = patch_cell_1(2) + (k-1)*h;

                  
                  cellMagnitudes= Gmag(cell_pixel_1y:cell_pixel_1y+h-1, cell_pixel_1x:cell_pixel_1x+w-1);
                  cellAngles = Gdir(cell_pixel_1y:cell_pixel_1y+h-1, cell_pixel_1x:cell_pixel_1x+w-1);

                %descriptor(j, k, :) = computeHOG(cellAngles(:),cellMagnitudes(:),nBins);
                descriptor(j, k, :) = histcounts(cellAngles(:), nBins,'BinLimits',[-pi,pi]);
            end
        end
        descriptors(i,:) = descriptor(:);
        
    end % for all local feature points
    
end
