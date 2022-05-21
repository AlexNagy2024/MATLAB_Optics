% Load thickness data and interpolate to a Cartesian coordinate system
%% Project 1 - Part 2, Nagy, 2/27/2022, Version 1.0
clear all, close all

% string initialized for accessing directories with lens data and images
d = ['C:\Users\nagya\Desktop\MATLAB\ME260\Projects\Project 1\Lens_Data_Batch1\Lens_Data_Batch1\'];
di = dir(d); % list folders within directory to access
for f = 1:length(di)-2 % loop through the folders
    dir2 = [d num2str(f) '\ThicknessProfile.csv']; % access thickness data
    file = fopen(dir2); % open thickness data
    % data types for columns
    data = textscan(file,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','Delimiter',',','HeaderLines',6);
    mat_data = cell2mat(data(2:end)); % index to only work with the data, not the strings
    file = fopen(dir2);
    header_data = textscan(file,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',1,'Delimiter',',','HeaderLines',4);
    theta = -1*cell2mat(header_data(2:end)) + 90; % data excluding labeling strings; all data with angles
    r_matrix = []; thk_matrix = []; % predefine radii and thickness vectors to fill
    for a = 1:2:length(theta) % loop through every other column, no redundancies w/ angles
        r = mat_data(:,a); t = mat_data(:,a+1); n = 1;
        while r(n)-(r(n+1)) == 0 % while loop for while column values start with zeros
            n = n + 1; % continue until no longer zeros
        end
        r = r(n+1:end); t = t(n+1:end); % overwrite r and t to start at valuable data
        for i = 1:length(r) % loop through the data (nonzero)
            if r(i) < -7 || r(i) > 7
                r(i) = NaN; % if data out of range make NaN
                t(i) = NaN; % if r data eliminated, t data is too
            else
                r(i) = r(i); % if data in range leave alone
                t(i) = t(i); % if r data left alone, t data is too
            end
        end
        t(isnan(t)) = []; r(isnan(r)) = []; % eliminate NaNs from data
        r_matrix = [r_matrix, r]; thk_matrix = [thk_matrix, t];
        coords(:,a) = r.*(cosd(theta(a))); % cartesian x coordinates
        coords(:,a+1) = r.*(sind(theta(a))); % cartesian y coordinates
    end
    x = coords(:,1:2:18); y = coords(:,2:2:18);
    grid = -7:0.1:7; [xg, yg] = meshgrid(grid,grid); % grid along x and y
    thickness = griddata(x,y,thk_matrix,xg,yg,'cubic'); % interpolated data
    figure % new figure for each lens iteration
    subplot(1,3,1) % 1st subplot: camera image
    cam_dir = [d num2str(f) '\CameraImage.png']; cam = imread(cam_dir); % read in data for image
    imshow(cam); hold on, title('Original Image'); axis square; % display lens; label; hold data
    subplot(1,3,2), surf(x,y,thk_matrix); hold on; view([0 0 1]); shading interp; axis square; 
    title('Original Thickness');
    subplot(1,3,3), surf(xg,yg,thickness); hold on; view([0 0 1]); shading interp; axis square; % interpolated plot
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); title('Interpolated Thickness'); % expand window
    
    figure
    plot3(x,y,thk_matrix,'.'), hold on; % plot the original data as dots
    plot3(xg,yg,thickness,'k.') % plot the regularized thickness data as black dots
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
    set(gcf,'color',[200 200 200]/250); grid on; % add grid and color background
    % 1x4 struct (lensprofile) made with xg, yg, and thickness data stored
    lensprofile(f).xg = xg; lensprofile(f).yg = yg; lensprofile(f).thickness = thickness;
end
save('Processed_Part_II','lensprofile'); % saves lensprofile structure as 'Processed_Part_II'