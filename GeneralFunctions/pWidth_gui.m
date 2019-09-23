function [ w_e, yMax, prof, pMaxPos] = pWidth_gui(prof, dy)

condfornan = 0;
if size(prof,1)==1
    prof = transpose(prof);
end
e=exp(1);
[pMax, pMaxPos] = max(prof,[],1);
yMax = pMaxPos * dy;
prof_n = prof / pMax;

pe = ceil(prof_n-1/e);
pe_0 = find(pe == 0);
pe_0_righttopmax = min(pe_0(pe_0>pMaxPos));

if pMaxPos == 1 && sym == 1
    pe_0_lefttopmax = 1;
    
elseif pMaxPos == 1 && sym == 0
    condfornan = 1;
    pe_0_lefttopmax = 1;
    
elseif pMaxPos == length(prof)
    condfornan = 1;
    pe_0_lefttopmax = 1;
    
else
    pe_0_lefttopmax = max(pe_0(pe_0<pMaxPos));
end

w_e = (pe_0_righttopmax - pe_0_lefttopmax -1)*dy;


if isempty(w_e) || condfornan
    w_e = NaN;
end
end