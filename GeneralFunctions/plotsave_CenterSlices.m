function plotsave_CenterSlices(sliXY, sliXZ , sliYZ, name, num_par)
    % plotXYZCenterSlices(volArr, w, strTitle)
    % w: the thickness of the slices around the center
    % strTitle: Title of Plot Windows
    
    %wh=round(w/2);
    %cx = round(size(volArr,1)/2);
    %cy = round(size(volArr,2)/2);
    %cz = round(size(volArr,3)/2);
    
    disp('New Function')
    scrsz = get(0,'ScreenSize');
    
    sliXYmax =  max(sliXY(:));
    sliXZmax =  max(sliXZ(:));
    sliYZmax =  max(sliYZ(:));
    
   % disp(['sx=' num2str(sx) ' sy=' num2str(sy) ' sz=' num2str(sz)])
    %disp(['XYmax=' num2str(sliXYmax) ' XZmax=' num2str(sliXZmax) ' YZmax=' num2str(sliYZmax)])
    
    figure('Name', ['Central Slices - '], 'Position', [10 scrsz(4)/3*2-100 scrsz(3)-20 scrsz(4)/3]);
    
    %plot and save XZ slice
    subplot(2,1,1);
    xax=[0 size(sliYZ,2)-1] * num_par.dz;
    yax=[-size(sliXZ,1)/2+1 size(sliXZ,1)/2]* num_par.dx; 
    if sliXYmax~=0
        imagesc(xax,yax,sliXZ, [0 sliYZmax]);
    else
        imagesc(xax,yax,sliXZ);
    end
   set(gca,'Ydir','normal')
    xlabel('z [µm]');
    ylabel('x [µm]');
    
    %plot and save YZ slice
    subplot(2,1,2);
    xax=[0 size(sliYZ,2)-1] * num_par.dz;
    yax = [-size(sliXY,1)/2+1 size(sliXY,1)/2]* num_par.dx;
    if sliXZmax~=0
        imagesc(xax,yax,sliYZ, [0 sliXZmax]);
    else 
        imagesc(xax,yax,sliYZ);
    end
     set(gca,'Ydir','normal')
     
    xlabel('z [µm]');
    ylabel('y [µm]');
   saveas(gcf,[name, '_CentralZ.png'])

   %plot and save XY slice
    figure()
    xax =[-size(sliXY,1)/2+1 size(sliXY,1)/2]* num_par.dx;
    yax = xax;
    
    if sliXZmax~=0
        imagesc(xax,yax,sliXY, [0 sliXYmax]);
    else
        imagesc(xax,yax,sliXY);
    end
    axis square
    set(gca,'Ydir','normal')
    xlabel('x [µm]');
    ylabel('y [µm]');
   
   saveas(gcf,[name, '_CentralXY.png'])
  
    % Image = getframe(gcf);
   %  imwrite(Image.cdata, name)%,'XResolution',900);
    
end