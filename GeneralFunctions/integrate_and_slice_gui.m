function [PSFSumZ,PSFSumY]=integrate_and_slice_gui(symGauss_illPSF_I,illPSF_Ix0,illPSF_EinBFP,cz,cy,cy_pad,num_par,phys_par,illPSF,phase)

%calculate slices at focal plane and prop axis
centerline = squeeze(symGauss_illPSF_I(cz,cy,:));
[maxIntX, pos_maxIntX] = max(centerline);
sliYZ = squeeze(symGauss_illPSF_I(:,:,pos_maxIntX));
sliXZ = squeeze(symGauss_illPSF_I(:,cy,:));
sliXY = squeeze(symGauss_illPSF_I(cz,:,:));


figure('Name', 'xy and yz sections of static beam')
subplot(2,1,1);
xax=[0 num_par.x_array_size-1] * num_par.dx;
yax=[-cy+1 cy]* num_par.dy;
imagesc(xax,yax,sliXY);
set(gca,'Ydir','normal')
xlabel('y [µm]');
ylabel('x [µm]');
axis('equal')

%plot and save YZ slice
subplot(2,1,2);
xax=[0 num_par.x_array_size-1] * num_par.dx;
yax = [-cy+1 cy]* num_par.dy;
imagesc(xax,yax,sliXZ);
set(gca,'Ydir','normal')
xlabel('y [µm]');
ylabel('z [µm]');
axis('equal')

%plot and save YZ slice
figure('Name', 'xz section of static beam')
xax =[-cy+1 cy]* num_par.dy;
yax = xax;
imagesc(xax,yax,sliYZ);
axis square
set(gca,'Ydir','normal')
xlabel('y [µm]');
ylabel('z [µm]');
axis('equal')
%%


%calculate integral along x and y
PSFSumZ = squeeze(sum(symGauss_illPSF_I,1));
PSFSumY = squeeze(sum(symGauss_illPSF_I,2));

figure('Name', 'yz section of scanned beam')
xax=[0 num_par.x_array_size-1] * num_par.dx;
yax=[-cy+1 cy]* num_par.dy;
imagesc(xax,yax,PSFSumY)
xlabel('y [µm]');
ylabel('z [µm]');
axis('equal')
xlim(xax)
ylim(yax)
set(gca,'Ydir','normal')

%calculate YZ section at x0 when scanning in y
PSF_scanY = squeeze(sum(sliYZ,2));
figure('Name', 'xz section of scanned beam')
xax=[-cy+1 cy]* num_par.dy;
yax = xax;
imagesc(xax,yax,PSF_scanY)
axis('square')
set(gca,'Ydir','normal')
xlabel('x [µm]');
ylabel('z [µm]');

%save images of BFP and z0
figure('Name', 'Amplitude & Phase in BFP')
subplot(1,2,1)
krObj = phys_par.k_0 * illPSF.NA;
sizeap =  ceil(krObj/num_par.dk)*2;
%EinBFP_crop =
etoshow = illPSF_EinBFP(cy_pad-cy+1:cy_pad+cy,cy_pad-cy+1:cy_pad+cy);
asq = abs(etoshow).^2;
%EinBFP_zoom = illPSF_EinBFP(cy_pad-sizeap:cy_pad+sizeap,cy_pad-sizeap:cy_pad+sizeap);
%asq = abs(EinBFP_zoom).^2;
xax=[-ceil(size(etoshow,1)/2)+1 ceil(size(etoshow,1)/2)]* num_par.dy;
yax = xax;
imagesc(xax,yax,real(asq))
axis('square')
set(gca,'Ydir','normal')
% xlabel('x [µm]');
% ylabel('z [µm]');


subplot(1,2,2)
%illPSF_Ix0_unpadded = illPSF_Ix0(cy_pad-cy+1:cy_pad+cy,cy_pad-cy+1:cy_pad+cy);
phasetoshow = phase(cy_pad-cy+1:cy_pad+cy,cy_pad-cy+1:cy_pad+cy);
xax=[-cy+1 cy]* num_par.dy;
yax = xax;
imagesc(xax,yax,real(phasetoshow))
axis('square')
set(gca,'Ydir','normal')
% xlabel('x [µm]');
% ylabel('z [µm]');
end

