function [s0,s1,s2,DOLP,AOLP] = calculateStokes(i0,i45,i90,i135)

s0 = 0.5*(i0 + i45 + i90 + i135);
s1 = i0 - i90;
s2 = i45 - i135;
DOLP = sqrt(s1.*s1 + s2.*s2)./(s0);
AOLP = (1/2) * atan2(s2,s1);
AOLP = AOLP * 180 / pi;
AOLP = mod(AOLP,180)/180.0;

s0 = s0/2;

DOLP(DOLP>1) = 1;
DOLP(DOLP<0) = 0;
DOLP(isnan(DOLP)) = 0;
DOLP(isinf(DOLP)) = 1;

if max(i0(:)) > 255 || max(i45(:)) > 255 || max(i90(:)) > 255 || max(i135(:)) > 255
    s1 = (s1 + 65535)/131070;
    s2 = (s2 + 65535)/131070;
    
elseif max(i0(:) < 1) || max(i45(:) < 1) || max(i90(:) < 1) || max(i135(:) < 1)
    
    s1 = (s1 + 1)/2;
    s2 = (s2 + 1)/2;
    

else
    
    s1 = (s1 + 255)/510;
    s2 = (s2 + 255)/510;
    
end



