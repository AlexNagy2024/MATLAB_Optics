% Summarize and present analyzed data
%% Project 1 - Part 4, Nagy, 2/27/2022, Version 1.0
clear all, close all, load('Processed_Part_III','Thickness','xg','yg')

% mean thickness and standard deviation across 4 lenses
avg_batch1 = mean(Thickness,3); std_batch1 = std(Thickness,0,3);
for i = 1:size(Thickness,3) % loop through thicknesses for each lens: batch 1
    subplot(1,4,i) % create subplot plot for each lens
    surf(xg,yg,Thickness(:,:,i)) % plot thickness for each lens: batch 1
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
    view([0 0 1]); shading interp; axis square; % set view, shading, axis
    [t, s] = title(['Lens #', num2str(i)],'Lens Batch 1'); s.FontAngle = 'italic';
end

figure, subplot(1,2,1) % new figure; new subplot of average thickness
surf(xg,yg,avg_batch1); title('Average Lens Thickness'); % plot avg thickness: batch 1
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
view([0 0 1]); shading interp; axis square; % set view, shading, axis

subplot(1,2,2) % subplot for standard deviation thickness
surf(xg,yg,std_batch1); title('Standard Deviation Thickness'); % plot std
view([0 0 1]); shading interp; axis square; % set view, shading, axis

batch2 = load('Lenses_Batch2.mat'); figure; % load lens batch 2; new figure
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
for p = 1:size(batch2.Thickness,3) % loop through lens batch 2
    subplot(1,5,p) % create a subplot for each lens in batch 2 data
    surf(xg,yg,batch2.Thickness(:,:,p)) %plot batch 2 lenses
    view([0 0 1]); shading interp; axis square; % set view, shading, axis
    [t, s] = title(['Lens #', num2str(p)],'Lens Batch 2'); s.FontAngle = 'italic';
end

lens_num = [1 2 3 4 5]; % array for removing lens but keeping proper lens title
Yes = 'Yes'; No = 'No'; % variables for yes and no; matches user input options
user_input = input('Are there any lenses that appear to be incorrectly included (Yes/No)? ');
if strcmp(user_input, Yes) % compare user input to predefined answer yes
    remove = input('Which lens would you like to remove (1-5)? ');
    batch2.Thickness(:,:,remove) = []; % remove lens via input
    lens_num(remove) = []; % remove lens number via input
elseif strcmp(user_input, No) % compare user input to predefined answer no
end

figure, set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
for n = 1:size(batch2.Thickness,3) % loop through NEW (1 element removed) size of batch2 lenses
    subplot(1,size(batch2.Thickness,3),n) % create a subplot for each lens in batch 2 data
    surf(xg,yg,batch2.Thickness(:,:,n)) % plot with 
    view([0 0 1]); shading interp; axis square; % set view, shading, axis
    [t, s] = title(['Lens #', num2str(lens_num(n))],'Lens Batch 2'); s.FontAngle = 'italic';
end
figure; set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1]); % expand window
avg_batch2 = mean(batch2.Thickness,3); std_batch2 = std(batch2.Thickness,0,3);

subplot(2,2,1), surf(xg,yg,avg_batch1); view([0 0 1]); % set view, shading, axis
shading interp; axis square; title('Lens Batch 1 Average Thickness'); % avg batch1

subplot(2,2,2), surf(xg,yg,avg_batch2); view([0 0 1]); % set view, shading, axis
shading interp; axis square; title('Lens Batch 2 Average Thickness'); % avg batch2

subplot(2,2,3), surf(xg,yg,std_batch1); view([0 0 1]); % set view, shading, axis
shading interp; axis square; title('Lens Batch 1 Standard Deviation Thickness'); 
% standard deviation plots of batch1 and batch2 
subplot(2,2,4), surf(xg,yg,std_batch2); view([0 0 1]); % set view, shading, axis
shading interp; axis square; title('Lens Batch 2 Standard Deviation Thickness'); 

avg_std1 = nanmean(nanmean(std_batch1)); avg_std2 = nanmean(nanmean(std_batch2)); % true avg stds displayed
fprintf('The average standard deviations of lens batches 1 and 2 are %fmm and %fmm respectively.\n',avg_std1,avg_std2)

if avg_std1 > avg_std2 % if deviation greater for 1, 2 is more consistent with manufacturing
    disp('Lens Batch 2 shows better consistency with manufacturing with a lower standard deviation.')
elseif avg_std2 > avg_std1 % if deviation greater for 2, 1 is more consistent with manufacturing
    disp('Lens Batch 1 shows better consistency with manufacturing with a lower standard deviation.')
end