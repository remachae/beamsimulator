function os_e = osWidth_gui(prof, num_par)
if size(prof,1)==1
    %disp('size(xDim)=1 -> transposing profile to measure width')
    prof = transpose(prof);
end
e=exp(1);
prof2 = cumsum(prof);
prof2_n = prof2 / max(prof2(:));

[~, p_maxint] = max(prof,[],1);
ny = num_par.y_array_size;

totalarea = sum(prof);
guessthickness_pxl = 3;
thickness63percent = 0;

while thickness63percent == 0
    guessthickness_pxl = guessthickness_pxl +1;
    if guessthickness_pxl == ny
        thickness63percent = NaN;
    end
    csum_norm = zeros(1,guessthickness_pxl);
    guessstartpoint = max(p_maxint-guessthickness_pxl+1,1);
    guessendpoint = min(p_maxint+guessthickness_pxl-1,ny)-guessthickness_pxl;
    
    for ii=guessstartpoint:guessendpoint
        csum_norm(ii) = sum(prof(ii:ii+guessthickness_pxl)) /totalarea;
        if ~(thickness63percent) &&  ~isempty(find(csum_norm(ii)>= 1-1/e,1))
            thickness63percent = guessthickness_pxl;
        end
    end
end


os_e = thickness63percent*num_par.dy;

end