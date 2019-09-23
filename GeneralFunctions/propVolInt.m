%% E_prop

function [I_prop, I_complex] = propVolInt(Ex0, prop, propBack, xStart, xEnd, cy, cy_pad)
    
    % function was tested with circAperture in BFP and yielded correct
    % results: NAcirc=0.3, n=1.33
    % numerical: FWHM: dz=12.7µm, dx=0.84µm
    % analytical for comparison: dz=12.8µm, dx=0.83µm
    
    xNum = xEnd - xStart - 1;
    I_prop = zeros([cy*2 cy*2 xNum]);
    I_complex = zeros([size(Ex0) xNum]);
    
    if xStart==0
        ExStart = Ex0;
        %I_prop(:,:,1) = abs(Ez0).^2;
    elseif xStart<0
        ExStart = myFFT(myFFT(Ex0,0).*(propBack.^(-xStart)),1);
        %I_prop(:,:,1) = abs(myFFT(myFFT(Ez0,0).*(propBack.^(-zStart)),1)).^2;
    elseif zStart>0
        ExStart = myFFT(myFFT(Ex0,0).*(prop.^xStart),1);
        %I_prop(:,:,1) = abs(myFFT(myFFT(Ez0,0).*(prop.^zStart),1)).^2;
    end
    I_prop(:,:,1) = abs(ExStart(cy_pad+1-cy:cy_pad+cy,cy_pad+1-cy:cy_pad+cy)).^2;
    I_complex(:,:,1) = ExStart;
    
    E_as = myFFT(ExStart, 0);
    
    kk=0;
    for xPos=1:xNum
        %disp(['z:' num2str(zPos)])
        %E_as =  circshift( fftshift( fft2( ifftshift( circshift( E_prop(:,:, zPos) , [1 1])))), [-1 -1] );
        %E_as = myFFT(I_prop(:,:,zPos), 0);
        
        E_as_prop = E_as .* prop;
        
        %E_prop(:,:, zPos+1) =  circshift( fftshift( ifft2( ifftshift( circshift( E_as_prop, [1 1]) ) ) ), [-1 -1]);
        I_complex(:,:,xPos+1) = myFFT(E_as_prop, 1);
        I_prop(:,:,xPos+1) = abs(I_complex(cy_pad+1-cy:cy_pad+cy,cy_pad+1-cy:cy_pad+cy,xPos+1)).^2;
        
        if (round(10*xPos/xNum) == kk)
            disp([num2str(kk*10) '%'])
            kk=kk+1;
        end
       
        E_as = E_as_prop;
    end
end