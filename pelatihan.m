clc; clear; close all; warning off all;

%source nama folder data latih
nama_folder = 'Citra Latih';
%membaca file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder, '*.jpg'));
%membaca jumlah file
jumlah_file = numel(nama_file);

%menginisialisasi variabel
area = zeros(1,jumlah_file);
perimeter = zeros(1,jumlah_file);
metric = zeros(1,jumlah_file);
eccentricity = zeros(1,jumlah_file);

%pengolahan citra terhadap seluruh citra
for n = 1:jumlah_file
    %membaca file citra rgb
    I = imread(fullfile(nama_folder,nama_file(n).name));
    %figure, imshow(I)
    %mengestrak komponen red dari citra rgb
    J = I(:,:,1);
    %figure, imshow(J)
    %melakukan thresholding terhadap komponen red
    K = imbinarize(J,.6);
  %  figure, imshow(K)
    %melakukan operasi komplemen
    L = imcomplement(K);
    %figure, imshow(L)
    
    %melakukan operasi morfologi
    %1. closing
    str = strel('disk',5);
    M = imclose(L,str);
    %figure, imshow(M)
    
    %2. filling holes
    N = imfill(M,'holes');
    %figure, imshow(N)
    
    %3. area opening
    O = bwareaopen(N,5000);
    %figure, imshow(O)
  
    %ekstraski ciri
    stats = regionprops(O,'Area','Perimeter','Eccentricity');
    area(n) = stats.Area;
    perimeter(n) = stats.Perimeter;
    metric(n) = 4*pi*area(n)/(perimeter(n)^2);
    eccentricity(n) = stats.Eccentricity;
end    

%menyusun variabel input
input = [metric;eccentricity];
%menyusun variabel target
target = zeros(1,jumlah_file);
target(1:6) = 1;    %Bougainvillea
target(7:12) = 2;    %Geranium
target(13:18) = 3;    %Magnolia
target(19:24) = 4;    %Pinus

%membangun arsitektur jaringan syaraf tiruan
rng('default')
net = newff(input,target,[20 5],{'logsig','logsig'},'trainlm');
%melakukan pelatihan jaringan
net = train(net,input,target);
%membaca nilai keluaran jaringan
output = round(sim(net,input));

%membaca akurasi
[m,n] = find(output==target);
akurasi = sum(m)/jumlah_file*100

%menyimpan arsitektur jaringan hasil pelatihan
save net net
