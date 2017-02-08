addpath(genpath('/mn/kadingir/domt_143903/HydrolabPIV/src'));
addpath('/mn/kadingir/domt_143903/HydrolabPIV/images');
javaaddpath('/mn/kadingir/domt_143903/HydrolabPIV/src/measures');
javaaddpath('/mn/kadingir/domt_143903/HydrolabPIV/src/interp');


% Read in wave images
im1 = imread('mpim1b.bmp');
mask1 = imread('mpim1bmask.bmp');
im2 = imread('mpim1c.bmp');
mask2 = imread('mpim1c.bmp');
coord = imread('mpwoco.bmp');

% Excercise 1 is solved below:
imagesc(coord) % Takes the picture with the marked coordinate points and shows it.
% Select reference points in pixel coordinate
h=impoly; % Creates lines between points.
pixel = h.getPosition; % Gets the position of the lines' points.

% Refine pixel positions (optional)
bw = im2bw(coord); % makes the coordinate image black and white
cc = bwconncomp(bw); % 
stats = regionprops(cc,'Centroid');
xc = vertcat(stats.Centroid);
idx = knnsearch(xc,pixel);
pixel = xc(idx,:);

% Define matching reference points in world coordinate
world = [wx(:) wy(:)];

% Create coordinate transformation
[tform,err,errinv] = createcoordsystem(pixel,world,'linear');


% Excercise 2, 3, 4 are solved below:

% Excercise 4
a = 0.0205; %m
w = 8.95; %1/s
k = 7.95; %1/m
z = linspace(-0.15,0.05,200);
U_ex = -a*w*exp(k*z);

figure
counter = 0;
for n = [64,56,48,46,44,40] % Subwindow size in pixels
    m = floor(n/3); %Search area size in pixels
    
    % Excercise 2:
    % First pass with masks
    opt1 = setpivopt('range',[-m m -m m],'subwindow',n,n,.50);
    piv1 = normalpass([],im1,mask1,im2,mask2,opt1);
    dt = 0.012;
    [U1,V1,x,y] = replaceoutliers(piv1,mask1&mask2);
    [Uw,Vw,xw,yw] = pixel2world(tform,U1,V1,x,y,dt);
   
    
    % Excercise 3:
    % Finding the lowest vertical velocity coordinate, ie. finding the
    % index for the column of piv1.V, where piv1.V has the lowest velocity.
    columnSize = 0;
    minimumColumnSize = 100000;
    columnIndex = 0;
    for i = 1:size(piv1.V,2)
        columnSize = sum(abs(piv1.V(:,i)))/size(piv1.V,2);
        if(columnSize < minimumColumnSize)
            minimumColumnSize = columnSize;
            columnIndex = i;
        end
    end
    
    % Plotting the different U velocities in world frame in each subplot.
    counter = counter + 1;
    subplot(3,2,counter)
    plot(Uw(:,columnIndex),yw(:,columnIndex))
    hold on
    
    % Excercise 4: Plotting the analytical solution
    plot(U_ex, z)
    hold on
   
    title(['Subwindow size = ', num2str(n), ' and search range = ', num2str(m), '.'])
    legend('PIV U','U exact')
    xlabel(' u [ m/s ] ');
    ylabel(' z [ m ] ');
end