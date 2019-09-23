%% Create Meshgrids for kx/ky - as well as for x/y - plots

% uses 
%   num_par.x_array_size
%   num_par.z_array_size
%   num_par.dk
%   num_par.dz
%   phys_par.k_med
% defines
%   kx
%   ky
%   kr
%   

%define x, y, z arrays for propagation in real space
%[ax, ay, az] = meshgrid( (-num_par.x_array_size/2 + 1) : (num_par.x_array_size/2), ...
%        (-num_par.x_array_size/2 + 1) : (num_par.x_array_size/2), ...
%        (-num_par.z_array_size/2 + 1) : (num_par.z_array_size/2));%
%
%x = single(num_par.dx*ax);
%y = single(num_par.dx*ay);
%z = single(num_par.dz*az);

x = (1:num_par.x_array_size) * num_par.dx;

%clear ax ay az;

%define kx, ky arrays - this way no rounding errors occur...
[ay, az] = meshgrid( (-num_par.pad_y_array_size/2+1 ) : (num_par.pad_y_array_size/2) ); 
ky = num_par.dk*ay; %single or not?
kz = num_par.dk*az;
y = num_par.dy*ay;
z = num_par.dy*az;
clear az ay;
kr = sqrt(ky.^2+kz.^2);
kphi = atan2(kz,ky);
kx = sqrt(phys_par.k_med^2 - ky.^2 - kz.^2);


% compute Propagator
H = exp(1i * kx * num_par.dx);
Hback = exp(1i *(-1) * kx * num_par.dx);

%no evanescent components
H( ky.^2 + kz.^2 > phys_par.k_med^2) = 0;
Hback( ky.^2 + kz.^2 > phys_par.k_med^2) = 0;

%Hap(zeros(size(H)));
fLP = exp(-(kr/2/num_par.dk).^2);
HAp = abs(H);
HPhase = angle(H);
HApLp = abs(ifftshift(ifft2(fft2(fftshift(fLP)).*fft2(fftshift(HAp)))));
HApLpNorm = HApLp / max(max(HApLp,[],1),[],2);
Hlp = HApLpNorm .* exp(1i*HPhase);

