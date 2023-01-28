clc; clear; close all; warning off all;

%source nama folder data latih
nama_folder = 'Citra Latih';
%membaca file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder, '*.jpg'));
%membaca jumlah file
jumlah_file = numel(nama_file);

%pengolahan citra terhadap seluruh citra
for n = 3:3
    %membaca file citra rgb
    I = imread(fullfile(nama_folder,nama_file(n).name));
    Imggray = double(rgb2gray(I));
    %Sobel
    Sobel = edge(Imggray,'sobel');
    figure,imagesc(Sobel),axis image,colormap gray, colorbar;
    %Prewit
    Prewit = edge(Imggray,'prewitt');
    figure,imagesc(Prewit),axis image,colormap gray, colorbar;
    %Robert
    Robert = edge(Imggray,'roberts');
    figure,imagesc(Robert),axis image,colormap gray, colorbar;
    %Laplacian of Gaussian
    Log = edge(Imggray,'log');
    figure,imagesc(Log),axis image,colormap gray, colorbar;
    %Otsu Thresholding
    Imggray2 = rgb2gray(I);
    bi = imbinarize(Imggray2);
    bi = imcomplement(bi);
    figure, imshow(bi)
end    

