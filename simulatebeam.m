function [symGauss_illPSF_I,illPSF_Ix0,illPSF_in_BFP,amp_in_BFP,phase_in_BFP,cy,cy_pad,cz,num_par,phys_par,illPSF] = simulatebeam(aptype, phasetype,  NA, sym,lambda,ref_index, varargin)
addpath('./GeneralFunctions')

disp('correct function')
flags.sym = sym;

prepare_data_gui
if nargin > 4
    if strcmp(phasetype,'airy')
        illPSF.phaseshift_at_aperture = varargin{1};

    end
    if strcmp(aptype,'double-gaussian')
        illPSF.NAsep = varargin{1};
        illPSF.bShift = [phys_par.k_0 * illPSF.NAsep 0];

    end
    if strcmp(aptype,'lattice')
        illPSF.epsilon = varargin{1};
        illPSF.NA = NA;
        illPSF.gP = ceil(phys_par.k_0 * illPSF.NA * sqrt(illPSF.epsilon)/num_par.dk);

    end
    if strcmp(phasetype,'SA')
        illPSF.sa_phase_amp = varargin{1};
    end
    

end

illPSF.ap_type = aptype;
illPSF.phase_type = phasetype;
illPSF.NA = NA;
dxPropIll = num_par.x_array_size;
if flags.sym == 0
    if strcmp(illPSF.phase_type,'SA')
        xStart = -dxPropIll/4;
        xEnd = dxPropIll/4*3;
    else
        xStart = -dxPropIll/2;
        xEnd = dxPropIll/2;
    end
elseif flags.sym == 1
    xStart = 0;
    xEnd = dxPropIll;
end

if strcmp(aptype,'uploadtiff')
    pad = num_par.pad_factor*num_par.y_array_size/2;
    amp_in_BFP = padarray(double(varargin{1,1}{1,1}),[pad/2 pad/2],0,'both');
    phase_in_BFP = padarray(double(varargin{1,1}{1,2}),[pad/2 pad/2],0,'both');
    illPSF_in_BFP = double(amp_in_BFP .* phase_in_BFP);
else
[illPSF_in_BFP,amp_in_BFP,phase_in_BFP] = compute_E_in_bfp( ...
    illPSF, num_par, phys_par, ky, kz, kr, kx, kphi, H, Hback, xStart, flags);
end

illPSF_Ex0 = myFFT(illPSF_in_BFP, 1);
illPSF_Ix0 = abs(illPSF_Ex0).^2;
[symGauss_illPSF_I, PSF_complex] = propVolInt(illPSF_Ex0, H, Hback, xStart, xEnd, cy, cy_pad);

clear ('Hback','HPhase','HApLpNorm','HApLp','Hlp','HAp','H','PSF_complex')
end
