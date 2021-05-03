clc
load('C:\Users\risha\Desktop\ETH\sem1\CV\Lab\codes\Lab_assignment_11\CV_Exercise_11_Revised\data\params.mat');

params.num_particles = 300; %300
params.hist_bin = 16; %16
params.model = 1;
params.alpha = 0.8;
params.sigma_velocity = 1; %1
params.initial_velocity = [1,10]; % [1,10],[5,0]
params.sigma_position = 15; % 15
params.sigma_observe = 0.009; %0.1 , 0.01
condensationTracker('video1',params);
