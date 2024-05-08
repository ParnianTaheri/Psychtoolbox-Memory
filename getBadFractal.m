function [selected_fractals, fractal_num] = getBadFractal(fractals, selected_fractals, num_bad, DS)
    ind1 = find(fractals == 0 & selected_fractals(DS, :) == 0);
    if (length(ind1) >= num_bad)
        fractal_num = ind1(randperm(length(ind1), num_bad));
        selected_fractals(DS, fractal_num) = 1;
    else
        selected_fractals(DS, fractals == 0) = 0;
        selected_fractals(DS, ind1) = 1;
        ind2 = find(fractals == 0 & selected_fractals(DS, :) == 0);
        fractal_num = [ind1 ind2(randperm(length(ind2), num_bad-length(ind1)))];
        selected_fractals(DS, fractal_num) = 1;
    end
end