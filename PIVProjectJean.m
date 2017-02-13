addpath(genpath('/mn/kadingir/domt_143903/HydrolabPIV/src'));
addpath('/mn/marduk/data/100_Jahre_Prandtl/VIDEO_TS/ReducedImageSquences/Sequence1');
addpath('/mn/marduk/data/100_Jahre_Prandtl/VIDEO_TS/ReducedImageSquences/Sequence2');
addpath('/mn/marduk/data/100_Jahre_Prandtl/VIDEO_TS/ReducedImageSquences/Sequence3');
addpath('/mn/marduk/data/100_Jahre_Prandtl/VIDEO_TS/ReducedImageSquences/Sequence4');
javaaddpath('/mn/kadingir/domt_143903/HydrolabPIV/src/measures');
javaaddpath('/mn/kadingir/domt_143903/HydrolabPIV/src/interp');



% Read in images
N = 209; %number of pictures

opt1 = setpivopt('savepeaks',true);

for k=1:N-1
    kk = 6038 + (k-1); %Change this number for the sequence you want
    % Change the name of the files to the appropriate name.
    im1 = imread(sprintf('all_images__0000%02d.jpg',kk));
    im2 = imread(sprintf('all_images__0000%02d.jpg',kk+1));
    if(k==1)
        piv1 = normalpass([],im1,[],im2,[],opt1);
    else
        piv1 = normalpass([],im1,[],im2,[],piv1);
    end
end

opt2=setpivopt('savepeaks',true,'savedisplacements',true);

for k=1:N-1
    kk = 6038 + (k-1); % Change this number for the sequence you want
    % Change the name of the files to the appropriate name.
    im1 = imread(sprintf('all_images__0000%02d.jpg',kk));
    im2 = imread(sprintf('all_images__0000%02d.jpg',kk+1));

    if(k==1)    
        piv2 = distortedpass(piv1,im1,[],im2,[],opt2);
    else
        piv2 = distortedpass(piv1,im1,[],im2,[],piv2);
    end
end

[U2,V2,x2,y2] = replaceoutliers(piv1);

figure
load wind
cav = curl(x2,y2,U2,V2);%plotting vorticity
pcolor(x2,y2,cav); shading interp
hold on;
quiver(x2,y2,U2,V2,'y')
hold off
colormap winter
xlabel(' u ');
c = colorbar;
ylabel(c,' z ');
axis ij

figure;
plot(U2,y2)
title('U component of velocity');
xlabel(' u ');
ylabel(' z ');

figure;
plot(V2,y2)
title('V component of velocity');
xlabel(' v ');
ylabel(' z ');