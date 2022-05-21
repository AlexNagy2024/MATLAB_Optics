% Load thickness data and interpolate to a Cartesian coordinate system
%% Project 1 - Part 3, Nagy, 2/27/2022, Version 1.0
clear all, close all, load('Processed_Part_I'); load('Processed_Part_II');

for i = 1:length(lensprofile)
    figure
    subplot(1,3,1) % surface plot of the thickness data from the lensprofile structure
    surf(lensprofile(i).xg,lensprofile(i).yg,lensprofile(i).thickness); % plot
    hold on; view([0 0 1]); shading interp; axis square; title('Lensprofile Data');
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
    
    center_x = table1.Center_Coords(i); center_y = table1.Center_Coords(i+4);
    toric_x = table1.ToricMark_Coords(i); toric_y = table1.ToricMark_Coords(i+4);
    toric_vec = [toric_x, toric_y]; % vectors to calculate angle to toric mark
    theta(i) = abs(atand((toric_y-center_y)/(toric_x - center_x))); % trig for angle
        % logic for orienting
        if toric_x - center_x > 0 && center_y - toric_y > 0 % quadrant 1
            theta(i) = 180 + (90-theta(i)); % angle necessary to align at 270 degrees
        elseif toric_x - center_x < 0 && center_y - toric_y > 0 % quadrant 2
            theta(i) = 90 + theta(i); % angle necessary to align at 270 degrees
        elseif toric_x - center_x < 0 && center_y - toric_y < 0 % quadrant 3
            theta(i) = 90 - theta(i); % angle necessary to align at 270 degrees
        elseif toric_x - center_x > 0 && toric_y - center_y < 0 % quadrant 4
            theta(i) = 90 + theta(i); % angle necessary to align at 270 degrees
        end
    
    subplot(1,3,2) % surface plot of rotated data
    R = [cosd(theta(i)) -sind(theta(i)); sind(theta(i)) cosd(theta(i))]; % rotation matrix
    % stack x points and y points; put into vector; rotate points; reshape to proper size
    points = [lensprofile(i).xg(:), lensprofile(i).yg(:)]'; rot_points = R*points;
    % reshape points to fit original size; plot rotated points; set shading and view
    rot_x = reshape(rot_points(1,:),[size(lensprofile(i).xg,1),size(lensprofile(i).xg,2)]);
    rot_y = reshape(rot_points(2,:),[size(lensprofile(i).yg,1),size(lensprofile(i).yg,2)]);
    surf(rot_x,rot_y,lensprofile(i).thickness); title('Rotated'); axis square;
    view([0 0 1]); shading interp; 
    
    subplot(1,3,3) % surface plot of interpolated data
    grid = -7:0.1:7; [xg, yg] = meshgrid(grid,grid); % grid for x and y
    Thickness(:,:,i) = griddata(rot_x,rot_y,lensprofile(i).thickness,xg,yg,'cubic');
    surf(xg,yg,Thickness(:,:,i)); view([0 0 1]); shading interp; axis square;
    title('Rotated and Reinterpolated');  % interpolate thickness data; plot new data
end
save('Processed_Part_III','Thickness','xg','yg'); % save Thickness, xg, yg variables