function py_fit = fitfunction(left_boundary,right_boundary,iteration,spe_or,sec_order)
    length = right_boundary - left_boundary +1;
    or_fit = spe_or(left_boundary:right_boundary);
    or_fit_x = 1:1:length;
    for i = 1:iteration 
        p = polyfit(or_fit_x,or_fit,sec_order);
        py_fit = polyval(p,or_fit_x);
        for j = 1:length
           if py_fit(j) <= or_fit(j)
              or_fit(j) = py_fit(j);
           end
        end
    end

end