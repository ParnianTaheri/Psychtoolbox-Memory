function [selected_fractals, fractal_num, fractal_pos] = getFractal(fractals, selected_fractals, display_size, trial_condition,window_size, rect)
    DS = (display_size-1)/2;

    if (trial_condition == "TA")
        [selected_fractals, fractal_num.bad] = getBadFractal(fractals, selected_fractals, display_size, DS);
    else
        ind1 = find(fractals == 1 & selected_fractals(DS, :) == 0);
        if (length(ind1) >= 1)
            fractal_num.good = ind1(randperm(length(ind1), 1));
            selected_fractals(DS, fractal_num.good) = 1;
        else
            selected_fractals(DS, fractals == 1) = 0;
            ind1 = find(fractals == 1 & selected_fractals(DS, :) == 0);
            fractal_num.good = ind1(randperm(length(ind1), 1));
            selected_fractals(DS, fractal_num.good) = 1;
        end
        [selected_fractals, fractal_num.bad] = getBadFractal(fractals, selected_fractals, display_size-1, DS);
    end
    width = window_size(1);
    height = window_size(2);
    r = height * 3/8;
    d_theta = 360 / display_size;
    thetas = (0:d_theta:360-d_theta) + randi(360);
    fractal_pos(1, :) = width/2 + rect(1) + r * cosd(thetas);
    fractal_pos(2, :) = height/2 - r * sind(thetas);
end
