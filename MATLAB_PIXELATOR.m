%% DREW'S WORKSHOP (Andrew Beyer)
%% MATLAB IMAGE PIXELATOR
%% 2024

clc;
clear all;

%% MARKERS AND SCALING (CHANGE-ABLE)
% These are the markers for each brightness range and their scaling

%GLOBAL
MarkerCount = 250; % the amount of dots across the axis
BackgroundColor = 'black'; % background color
AxisColor = 'yellow'; % axis color
ImageScaling = 900; %usually do not need to adjust the image scaling

%LIGHT
MarkerL = '*'; % marker type
ScalingL = 4; % scaling the size of the marker

%MEDIUM
MarkerM = 'o'; % marker type
ScalingM = 10; % scaling the size of the marker

%DARK 
MarkerD = 'o'; % marker type
ScalingD = 10; % scaling the size of the marker

%BLACK 
%(look at scatter sectiobn below, input should'nt matter, usually commented
%out to have no markers in the black regions)
MarkerB = '*'; % marker type
ScalingB = 30; % scaling the size of the marker

%% EXTRAS... (CHANGE-ABLE)
% Here is a couple more marker types to add to picture

%extra 
MarkerE = 'o'; % marker type
ScalingE = 20; % scaling the size of the marker

%extra 2
MarkerE2 = '*'; % marker type
ScalingE2 = 40; % scaling the size of the marker


%% IMAGE COLOR ADJUSTMENT (CHANGE-ABLE)
% try various compbinations of R, G, and B values 
% try values from 0.0 to 1.0

R = 0.0;
G = 0.1;
B = 0.5;

%% IMAGE SETUP (CHANGE-ABLE)

I = imread("PATH_2_IMAGE_HERE.jpg"); %This is where you set the path to your image 
[y1, x1, ~] = size(I);       

%% DOTS
markersizeX = x1 / MarkerCount;  
markersizeY = y1 / MarkerCount; 

%% PLOT SETUP
figure(1)

ax = gca;
window_x = (x1/y1) * ImageScaling;

ax.XColor = AxisColor;
ax.YColor = AxisColor;

ax.Color = BackgroundColor;

set(gcf, 'Position', [400 100 window_x 900],'Color', BackgroundColor) 
axis([0 x1 0 y1]);
hold on

%% COORDINATES, RGB, AND BRIGHTNESS COMPUTATION
[X, Y] = meshgrid(0:(MarkerCount - 1), 0:(MarkerCount - 1));
x_coords = X(:) * markersizeX;
y_coords = Y(:) * markersizeY;

RGB = zeros(MarkerCount^2, 3);
for idx = 1:MarkerCount^2
    RGB(idx, :) = I(round(y1 - (Y(idx) + 1) * markersizeY) + 1, round(X(idx) * markersizeX) + 1, :);
end

brightness = 0.21 * RGB(:, 1) + 0.72 * RGB(:, 2) + 0.07 * RGB(:, 3);

%% MARKER RANGE (CHANGE-ABLE)
% I would recommend running the code and looking at the HISTOGRAM figure to
% determine the ranges for the markers. Based on the figure try to space
% the marker ranges evenly along the brightness levels apparent in the
% image. The brightnness range is from 1 to 250. If you decide not to use
% the extra and extra2 markers, be sure to comment them out below and fill
% the gap in brightness range with the other markers. 

% lightest point of image
light = brightness >= 180;
medium = (180 > brightness) & (brightness >=120);
dark = (120 > brightness) & (brightness >=100);
extra2= (100 > brightness) & (brightness >=85);
extra= (85 > brightness) & (brightness >=77);
black= (77 > brightness) & (brightness >=1);
% darkest point of image


%% SCALING CALCULATIONS
% Marker size scaling based on brightness for each category
MarkerSizeL = (brightness(light) * (ScalingL/255));
MarkerSizeM = (brightness(medium) * (ScalingM/255));
MarkerSizeD = (brightness(dark) * (ScalingD/255));
MarkerSizeB = (brightness(black) * (ScalingB/255));
MarkerSizeE = (brightness(extra) * (ScalingE/255));
MarkerSizeE2 = (brightness(extra2) * (ScalingE2/255));

%% COLOR TRANSFORMATION
transform_color = @(rgb) mod(rgb + [R G B], 1);

%% SCATTER PLOTS (CHANGE-ABLE)
% Comment out the markers that you do not want plotted.
% I usually comment out the black region, personally like the look.

scatter(x_coords(light), y_coords(light), MarkerSizeL, transform_color(double(RGB(light,:))/255), MarkerL)
scatter(x_coords(medium), y_coords(medium), MarkerSizeM, transform_color(double(RGB(medium,:))/255), MarkerM, 'filled');
scatter(x_coords(dark), y_coords(dark), MarkerSizeD, transform_color(double(RGB(dark,:))/255), MarkerD, 'filled');
%scatter(x_coords(black), y_coords(black), MarkerSizeB, transform_color(double(RGB(black,:))/255), MarkerB, 'filled');
scatter(x_coords(extra), y_coords(extra), MarkerSizeE, transform_color(double(RGB(extra,:))/255), MarkerE, 'filled');
scatter(x_coords(extra2), y_coords(extra2), MarkerSizeE2, transform_color(double(RGB(extra2,:))/255), MarkerE2, 'filled');

%% HISTOGRAM
% This is very helpful in determining the range of brightness that each
% marker should fall into.
% I usually comment this out once I find a range of values I like for the
% MARKER RANGE section.

figure(2);
ax_hist = gca;

ax_hist.XColor = AxisColor;
ax_hist.YColor = AxisColor; 

% Set plot background color
ax_hist.Color = BackgroundColor;

histogram(brightness, 'FaceColor', 'cyan', 'EdgeColor', 'none');
xlabel('Brightness Levels');
ylabel('Frequency');
title('Histogram of Brightness Levels');

set(gcf, 'Position', [500 100 600 400]);
