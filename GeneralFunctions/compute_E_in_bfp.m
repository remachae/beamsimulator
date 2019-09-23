function [E_in_BFP,amp_in_BFP,phase_in_BFP]  = compute_E_in_bfp(beam_par, num_par, phys_par, ky, kz, kr, kx)

    amp_in_BFP = double(zeros(size(kr)));
    ap_Obj = single(zeros(size(kr)));
    krAp = phys_par.k_0 * beam_par.NA;
    krObjAp = phys_par.k_0 * beam_par.NAobj;
    
    cx=size(kx,1)/2;
    cy=size(kx,2)/2;
    
    switch beam_par.ap_type
        case 'circ'
            disp('Aperture type : homogeneous')
            amp_in_BFP( kr < krAp ) = 1;
        case 'lattice'
            disp('Aperture type : square lattice')
            amp_in_BFP = exp( -((kr - krAp*(1+sqrt(beam_par.epsilon))/2)*2 / (phys_par.k_0 * beam_par.NA *( 1-sqrt(beam_par.epsilon)))).^2);
            grid = floor((mod(round(ky/num_par.dk)-1,beam_par.gP)+1)/beam_par.gP);
             amp_in_BFP = amp_in_BFP.* grid;

        case 'gaussian'
            disp('Aperture type : gaussian')
            amp_in_BFP = exp( -(kr / krAp).^2);

        case 'double-gaussian'
            disp('Aperture type : double gaussian')
            ky1 = ky + beam_par.bShift(2);
            kz1 = kz + beam_par.bShift(1);
            kr = sqrt(ky1.^2+kz1.^2);
            gaAmp1 = exp( -(kr / krAp).^2);

            ky2 = ky - beam_par.bShift(2);
            kz2 = kz - beam_par.bShift(1);
            kr2 = sqrt(ky2.^2+kz2.^2);
            gaAmp2 = exp( -(kr2 / krAp).^2);
            
            amp_in_BFP = gaAmp1 + gaAmp2;
    end

    switch beam_par.phase_type
        case 'airy'
            disp('Phase type: cubic phase mask')
            a = beam_par.phaseshift_at_aperture / krAp^3;
            beam_par.rot_angle = 0;
            kyR = ky * cos(beam_par.rot_angle) - kz * sin(beam_par.rot_angle);
            kzR = ky * sin(beam_par.rot_angle) + kz * cos(beam_par.rot_angle);
            phase_in_BFP = exp(1i * a * (kyR.^3 + kzR.^3));
        case 'SA'
            disp('Phase type: biquadratic phase mask')
            phase_in_BFP = exp(1i * beam_par.sa_phase_amp * kr.^4);

        otherwise
            disp('Phase type: plane phase')
      phase_in_BFP = single(ones(size(kr)));
    end
    
    
    E_in_BFP = double(amp_in_BFP .* phase_in_BFP);
    
    if beam_par.NAobj~=0
        krObj = phys_par.k_0 * beam_par.NAobj;
        ap_Obj(kr < krObj) = 1;
        E_in_BFP = E_in_BFP .* ap_Obj;
        
    end
    
end