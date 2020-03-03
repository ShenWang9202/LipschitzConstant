% Main Program
% Lipschitz constant computation using Analytical, interval-based, and
% point-based method
% System: water distribution system model
% Author: Shen Wang
% Date: 2/27/2020


clc;
clear;
close all;


for  inpNameIndex = 1:1
    switch inpNameIndex
        case 1
            disp('Threenodes.inp');
        case 2
            disp('tutorial8node.inp');
        case 3
            disp('Anytown.inp');
        case 4
            disp('Net2.inp');
        case 5
            disp('Net3.inp');
        case 6
            disp('OBCL.inp');
        otherwise
            disp('other value');
    end
    
    %% Find Lipschitz via anlytical solution
    FindLipschitz_v2
    
    %% Find Lipschitz via interval algebra
    main_program_interval
    
    % the result is printed and stored in variable: Lip
    
    %% Find Lipschitz via point based (max mode and sqrt mode)
    % note that 1) the max mode should be close to anlytical solution 2) the
    % sqrt mode should be close to interval algebra result
    
    for j = 1:2
        if (j==1)
            mode_point_based = 'sqrt';
        else
            mode_point_based = 'max';
        end
        main_program_point_based
    end
    
    
    
    % the final result is stored in the following cell
    
    % vmean_f_h
    % vmean_f_r
    % vmean_f_s
    
    
end


