function [display_size, trial_condition] = conditions(DS, num_trial)
    display_size = zeros(1, num_trial);
    trial_condition = strings(1, num_trial);
    group_condition = strings(1, num_trial);
    
    display_size(1:num_trial/4) = DS(1);
    display_size(num_trial/4+1:num_trial/2) = DS(2);
    display_size(num_trial/2+1:3*num_trial/4) = DS(3);
    display_size(3*num_trial/4+1:num_trial) = DS(4);
    display_size = display_size(randperm(num_trial));
    
    tc_tmp(1:num_trial/8) = "TP";
    tc_tmp(num_trial/8+1:num_trial/4) = "TA";
    
    trial_condition(display_size == DS(1)) = tc_tmp(randperm(num_trial/4));
    trial_condition(display_size == DS(2)) = tc_tmp(randperm(num_trial/4));
    trial_condition(display_size == DS(3)) = tc_tmp(randperm(num_trial/4));
    trial_condition(display_size == DS(4)) = tc_tmp(randperm(num_trial/4));
end
