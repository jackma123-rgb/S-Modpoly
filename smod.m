function [smod_baseline, smod_spe] = smod(iteration,need_width,ori_order,sec_order,fin_order,spe_wb)
    spe_or = spe_wb;
    pixels_number = length(spe_wb);
    x = 1:1:pixels_number;
    p = polyfit(x,spe_wb,ori_order);
    setarray = polyval(p,x);
    left_intersection = [];
    right_intersection = [];
    for compare = 1: pixels_number -1
        if setarray(compare) >= spe_or(compare) && setarray(compare+1) <= spe_or(compare+1)
            left_intersection(end + 1) = compare;
        elseif setarray(compare) <= spe_or(compare) && setarray(compare+1) >= spe_or(compare+1)
            right_intersection(end + 1) = compare;
        end
    end
        if right_intersection(1) <= left_intersection(1)
            left_intersection = [0,left_intersection];
        end
        if left_intersection(end) >= right_intersection(end)
            right_intersection = [right_intersection,pixels_number];
        end
    or_width = max(right_intersection - left_intersection);
   
    opeaks = round((right_intersection +left_intersection)/2);
    ipeaks = spe_or(opeaks) - setarray(opeaks);
    mpeaks = max(ipeaks);
    peaks = [];
    for i = 1:length(opeaks)
        if abs(spe_or(opeaks(i)) - setarray(opeaks(i))) > 0.05*mpeaks
            peaks(end + 1) = opeaks(i);
        end
    end
    
    left_boundary = 1;
    right_boundary = need_width.*or_width;
    spe_1 = zeros(1,pixels_number);
    while left_boundary < pixels_number 
        peaks_num = floor(abs((pixels_number-right_boundary))/or_width)*2;
        if peaks_num == 0 
            right_boundary = pixels_number;
            fitarray = fitfunction(left_boundary,right_boundary,iteration,spe_or,sec_order);
            spe_1(left_boundary:right_boundary) = fitarray;
            break
        elseif right_boundary >= pixels_number
            right_boundary = pixels_number;
            fitarray = fitfunction(left_boundary,right_boundary,iteration,spe_or,sec_order);
            spe_1(left_boundary:right_boundary) = fitarray;
            break
        end
        for pn = 1:peaks_num 
            right_differ = abs(peaks - right_boundary);
            [right_differ_min] = min(right_differ);
            if right_differ_min <= 0.5*or_width
                right_boundary = floor(right_boundary + or_width/2);
            elseif right_differ_min >= or_width*0.5
                break
            end
        end

        fitarray = fitfunction(left_boundary,right_boundary,iteration,spe_or,sec_order);
        spe_1(left_boundary:right_boundary) = fitarray;
        left_boundary = right_boundary;
        right_boundary = floor(left_boundary + need_width.*or_width);

    end
    last = polyfit(x,spe_1,fin_order);
    last_fit = polyval(last,x);
    
    last_fitc = last_fit;
    if pixels_number - peaks(end) >= or_width
        last_fitc(fix(peaks(end)+0.7*or_width):pixels_number) = spe_wb(fix(peaks(end)+0.7*or_width):pixels_number);
    end
    if peaks(1) >= or_width
        last_fitc(1:0.4*or_width) = spe_wb(1:0.4*or_width);
    end
    last2 = polyfit(x,last_fitc,fin_order);
    last_fit = polyval(last2,x);

    smod_baseline = last_fit;
    smod_spe = spe_wb - last_fit;

end