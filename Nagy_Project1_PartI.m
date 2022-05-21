% Write a script that reads in camera images of the contact lenses, and identifies how it will need to be rotated so that all lenses have the same orientation. 
%% Project 1 - Part 1, Nagy, 2/27/2022, Version 1.0
clear all, close all

% string initialized for accessing directories with lens data and images
d = ['C:\Users\nagya\Desktop\MATLAB\ME260\Projects\Project 1\Lens_Data_Batch1\Lens_Data_Batch1\']; 
di = dir(d); % list folders within directory to access
for i = 1:length(di)-2 % loop through folders; avoid unuseful data
    i_dir = [d num2str(i) '\']; % index by i for each folder and add backslash
    idx_idir = dir(i_dir); cam = idx_idir(3).name; % access CamerImage.png
    f_dir = [i_dir cam]; orig = imread(f_dir); % final directory
    thresh = im2bw(orig,0.6); % threshold image to identify toric mark
    Cloc_thresh = regionprops(thresh,'centroid','area'); % find centroid
    area = cat(1, Cloc_thresh.Area); [~, loc] = max(area); % take the largest area
    
    figure % new figure for each iteration
    subplot(1,2,1) % subplot of thresholded image
    imshow(thresh); hold on, title('Thresholded Image'); % label; hold data
    plot(Cloc_thresh(loc).Centroid(1),Cloc_thresh(loc).Centroid(2),'r*'); % plot centroid
    subplot(1,2,2) % subplot of the original image
    imshow(orig); hold on, title('Original Image'); % label; hold data
    plot(Cloc_thresh(loc).Centroid(1),Cloc_thresh(loc).Centroid(2),'r*') % plot centroid
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
    
    c = drawcircle; % user draws circle tracing lens
    get(c); set(c,'color','m'); axis on; % get circle data; color circle
    center = get(c,'center'); % circle center 
    rad = get(c,'radius'); % circle radius
    
    % store toric mark centroids into array for table
    ToricMark_Coords(i,:) = [Cloc_thresh(loc).Centroid(1),Cloc_thresh(loc).Centroid(2)];
    Center_Coords(i,:) = [center]; % store values of center into array for table
    Lens_Radius(i) = [rad]; % store values or radii into array for table
end
Lens_Radius = Lens_Radius'; % transpose radii data to be of same size as other table elements
Lens = [1:4]'; % lens # for data table
close all; table1 = table(Lens,ToricMark_Coords,Center_Coords,Lens_Radius) % table; close figs
save('Processed_Part_I', 'table1'); % save data table