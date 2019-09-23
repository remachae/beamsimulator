function [os, ml, length] = analysisbeam_gui(PSFSumY,cy,num_par)

%PSFSumY = squeeze(sum(illPSF_mat,2));

%calculate width of profile along z

centerline = PSFSumY(cy,:);
[dfocus_e, ~, ~, pMaxPos] = pWidth_gui(centerline,num_par.dx);

if ~isnan(dfocus_e)
    %for point of max intensity along z, pMaxPos, and pMaxPos+fwhm/2,
    %calculate optical sectioning and main lobe width along y
    prof_peak = PSFSumY(:,pMaxPos);
    os_peak_e = osWidth_gui(prof_peak, num_par);
    
    

    [wpeak_e, ~, ~,~] = pWidth_gui(prof_peak,num_par.dy);
    
    
    nx = num_par.x_array_size;

    we = zeros(1,nx);

    for ix = 1:nx
        prof = PSFSumY(:,ix);
        we(ix) = osWidth_gui(prof, num_par);
    end
    
    x2OS_e = doubleOS(we,  num_par.dx,num_par.x_array_size);
    
else
    os_peak_e = NaN; 
    wpeak_e= NaN;
    x2OS_e = NaN; 
end

    length = x2OS_e;
    os = os_peak_e;
    ml = wpeak_e;

end
