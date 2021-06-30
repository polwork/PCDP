clc
close all;
clear all;

%% read poalrization images
I0 = double(imread('woodwall_0.png'));
I45 = double(imread('woodwall_0.png'));
I90 = double(imread('woodwall_0.png'));
I135 = double(imread('woodwall_0.png'));

%% choose green channel
I0 = I0(:,:,2);
I45 = I45(:,:,2);
I90 = I90(:,:,2);
I135 = I135(:,:,2);

%% make mosaic and mask images as input(both H x W x 4)
if mod(size(I0,1),2) == 1
    I0 = I0(1:end-1,:);
    I45 = I45(1:end-1,:);
    I90 = I90(1:end-1,:);
    I135 = I135(1:end-1,:);
end
if mod(size(I0,2),2) == 1
    I0 = I0(:,1:end-1);
    I45 = I45(:,1:end-1);
    I90 = I90(:,1:end-1);
    I135 = I135(:,1:end-1);
end

[S0,S1,S2,DOLP,AOLP] = calculateStokes(I0,I45,I90,I135);
polar = cat(3,I0,I45,I90,I135);

mosaic = zeros(size(polar,1), size(polar,2), 4);
mask = zeros(size(polar,1), size(polar,2), 4);

rows1 = 1:2:size(polar, 1);
rows2 = 2:2:size(polar, 1);
cols1 = 1:2:size(polar, 2);
cols2 = 2:2:size(polar, 2);

mask(rows1, cols1, 1) = 1;
mask(rows1, cols2, 2) = 1;
mask(rows2, cols1, 4) = 1;
mask(rows2, cols2, 3) = 1;

mosaic(:,:,1) = polar(:,:,1) .* mask(:,:,1);
mosaic(:,:,2) = polar(:,:,2) .* mask(:,:,2);
mosaic(:,:,3) = polar(:,:,3) .* mask(:,:,3);
mosaic(:,:,4) = polar(:,:,4) .* mask(:,:,4);

%% demosaic
[I0_pcdp,I45_pcdp,I90_pcdp,I135_pcdp] = pcdp(mosaic,mask);

%% calculate Stokes parameters
[S0_pcdp,S1_pcdp,S2_pcdp,DOLP_pcdp,AOLP_pcdp] = calculateStokes(I0_pcdp,I45_pcdp,I90_pcdp,I135_pcdp);

%% calculate psnr and ssim values
psnr_s0_pcdp = psnr(uint8(S0_pcdp(17:end-16,17:end-16)), uint8(S0(17:end-16,17:end-16)));
psnr_dolp_pcdp = psnr(DOLP_pcdp(17:end-16,17:end-16), DOLP(17:end-16,17:end-16));
psnr_aolp_pcdp = psnr_aop(AOLP_pcdp(17:end-16,17:end-16), AOLP(17:end-16,17:end-16));

