function yy = smooth_f(y, span)
% SMOOTH_F Smoothing function - moving average with a window centered around the
% current position.  The span dictates how much to incorporate into the average
% from the current position.  If the span is an even number, it will not have
% a 'true' median equal to the current position. The window will be skewed toward
% the smaller values.
%
% INPUTS:
%     y:        A vector whose values need to be smoothed. span - Size of the averaging window.
%     span:     An integer value that equals the size of the averaging window.  It is
%               recommended to use an odd value (i.e. 51)
%
% OUTPUTS:
%     yy: The y vector that has been smoothed using an averaging window.
%
% Author(s): Unknown (original)
%            Jonathan Cook (refactored)
%
% Created:   Unknown (original)
%            2018-07-12 (refactored)

yy = y;
l = length(y);

for i = 1 : l
    if i < span
        d = i;
    else
        d = span;
    end
    
    w = d - 1;
    p2 = floor(w / 2);
    
    if i > (l - p2)
        p2 = l - i;
    end
    
    p1 = w - p2;
    
    yy(i) = sum(y(i - p1 : i + p2)) / d;
end
end