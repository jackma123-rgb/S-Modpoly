clc
clear
close all
%% 
load("spe.mat");
iteration = 5;
need_width = 3;
ori_order = 10; % fsin 5; expo 4; gaus 10; poly 4; sigm 6
sec_order = 2; 
fin_order = 10; % fsin 5; expo 4; gaus 10; poly 4; sigm 6
spe_or = spe_gaus;

tic
[smod_baseline, smod_spe] = smod(iteration,need_width,ori_order,sec_order,fin_order,spe_or);
toc

pixels_number = length(spe_or);
x = 1:1:pixels_number;
figure;
plot(x,spe_or,x,smod_baseline,'LineWidth',1);
figure;
plot(x,smod_spe,'LineWidth',1);