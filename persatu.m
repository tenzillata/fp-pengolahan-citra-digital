clc; clear; close all; warning off all;

%memanggil menu browse file
[nama_file,nama_folder] = uigetfile('*.jpg');

%jika ada nama file yang dipilih akan dieksekusi
if ~isequal(nama_file,0)

    %membaca file citra rgb
    I = imread(fullfile(nama_folder,nama_file));
    %figure, imshow(I)
    %mengestrak komponen red dari citra rgb
    J = I(:,:,1);
   % figure, imshow(J)
    %melakukan thresholding terhadap komponen red
    K = imbinarize(J,.6);
  %  figure, imshow(K)
    %melakukan operasi komplemen
    L = imcomplement(K);
 %   figure, imshow(L)
    
    %melakukan operasi morfologi
    %1. closing
    str = strel('disk',5);
    M = imclose(L,str);
 %   figure, imshow(M)
    
    %2. filling holes
    N = imfill(M,'holes');
 %   figure, imshow(N)
    
    %3. area opening
    O = bwareaopen(N,5000);
  %  figure, imshow(O)
  
    %ekstraski ciri
    stats = regionprops(O,'Area','Perimeter','Eccentricity');
    area = stats.Area;
    perimeter = stats.Perimeter;
    metric = 4*pi*area/(perimeter^2);
    eccentricity = stats.Eccentricity;
    

%menyusun variabel input
input = [metric;eccentricity];

%memanggil arsitektur jaringan
load net

%membaca nilai keluaran jaringan
output = round(sim(net,input));

%mengkonversi nilai keluaran jaringan menjadi kelas
if output==1
    kelas = 'Bougainville';
elseif output==2
    kelas = 'Geranium';
elseif output==3
    kelas = 'Magnolia';
elseif output==4
    kelas = 'Pinus';
else
    kelas = 'Tidak Dikenal';
end

figure, imshow(I)
title({['Nama File: ',nama_file],['Kelas Keluaran: ',kelas]})

else
    return
end
