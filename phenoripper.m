function phenoripper
current_dir=pwd;
addpath(genpath([current_dir filesep 'engine']));
addpath(genpath([current_dir filesep 'gui']));
addpath(genpath([current_dir filesep 'util']));
addpath(genpath([current_dir filesep 'data']));
addpath(genpath([current_dir filesep 'img']));
version=fileread('version.txt');
disp(['PhenoRipper version ' version]);
phenoripper_gui;
