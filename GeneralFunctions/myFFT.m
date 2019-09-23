function ar_FFT = myFFT(ar, tType)
    % tType = 0: Forward FFT (real space -> k-space)
    % tType = 1: backward FFT (k-space -> real space)
    if tType==0
        ar_FFT = circshift( ifftshift( fft2( fftshift( circshift( ar , [1 1])))), [-1 -1] );
    else
        ar_FFT = circshift( fftshift( ifft2( ifftshift( circshift( ar , [1 1])))), [-1 -1] );
    end 
end