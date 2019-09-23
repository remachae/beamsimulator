
function z2 = doubleOS(profile, sym, dz, z)
        
        if sym
            a = find(profile >= 2 * min(profile), 1);
            if a == z
                z2 = NaN;
            else
                z2 = 2 * a * dz;
            end
            
        else
            [minprof, z_minprof] = min(profile);
            b = find(profile(z_minprof:end) >= 2*minprof,1);
            c = find(profile(1:z_minprof) >= 2*minprof,1,'last');
            
            if isempty (c) || isempty(b)
                z2 = NaN;                
            elseif b == 1 || c == z
                z2 = NaN;
            else
                z2 = ((z_minprof -1 + b) - c) * dz;
            end
           
        end