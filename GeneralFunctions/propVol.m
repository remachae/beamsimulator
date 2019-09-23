%% E_prop

function E_prop = propVol(Ez0, prop, propBack, zStart, zEnd)
    
    % function was tested with circAperture in BFP and yielded correct
    % results: NAcirc=0.3, n=1.33
    % numerical: FWHM: dz=12.7µm, dx=0.84µm
    % analytical for comparison: dz=12.8µm, dx=0.83µm
    
    zNum = zEnd - zStart - 1;
    E_prop = zeros([size(Ez0) zNum]);
    
    if zStart==0
        E_prop(:,:,1) = Ez0;
    elseif zStart<0
        E_prop(:,:,1) = myFFT(myFFT(Ez0,0).*(propBack.^(-zStart)),1);
    elseif zStart>0
        E_prop(:,:,1) = myFFT(myFFT(Ez0,0).*(prop.^zStart),1);
    end
    
    for zPos=1:zNum
        E_as = myFFT(E_prop(:,:,zPos), 0);
        E_as_prop = E_as .* prop;
        E_prop(:,:, zPos+1) = myFFT(E_as_prop, 1);
    end
end