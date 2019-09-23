%% ******* Prepare Data *******
%  ****************************

phys_par.n_med = ref_index;                              % refractive index of medium
phys_par.l_0 = lambda/1000;


if  strcmp(excitation,'Linear')
    num_par.l_pixel = 8;              % wavelength in medium in pixel
    num_par.x_array_size = 64;
elseif strcmp(excitation,'Two photon')
    num_par.l_pixel = 16;
    num_par.x_array_size = 2*64;
end
num_par.y_array_size = 512;                         % size of array in y-z-dimension
                % size of x-array (prop direction) in pixels (how many pixels do we propagate?)

num_par.pad_factor =4;
num_par.pad_y_array_size = num_par.pad_factor * num_par.y_array_size;                     % size of array in x-y-dimension

num_par.scale_dx = 16;                              % scale factor for resolution in z-direction (if 1 dz = dx)

derivePhysicalAndNumericalParameters;

createMeshgrids;

cy_pad = num_par.pad_y_array_size / 2;
cy = num_par.y_array_size / 2;
cz = num_par.y_array_size / 2;
cx = num_par.x_array_size / 2;


%values by default
illPSF.genType = 'E_in_bfp';
illPSF.phase_type = '';
illPSF.kx_max = 0;
illPSF.NAobj = 1.0;
illPSF.pos_type = '';

