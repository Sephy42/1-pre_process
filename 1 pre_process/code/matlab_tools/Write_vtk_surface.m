function []=Write_vtk_surface(Pts, Tri, Normals, Scalars, LUT, filename,Scalars2)

% Usage:
% Write_vtk_surface(Pts, Tri, Normals, Scalars, LUT, filename);

fid = fopen(filename, 'w');

fprintf(fid, '# vtk DataFile Version 3.0\nvtk output\nASCII\n');
fprintf(fid, 'DATASET POLYDATA\n');
fprintf(fid, 'POINTS %d float\n',length(Pts));

fprintf(fid, '%f %f %f\n',Pts.');

fprintf(fid, 'POLYGONS %d %d\n', length(Tri), 4*length(Tri));
fprintf(fid,'%d %d %d %d\n',[repmat(3,size(Tri,1),1),Tri-1].');



if( ~isempty(Scalars) ) % write the scalars if any
    fprintf(fid,'\nCELL_DATA %d\nPOINT_DATA %d\n',length(Tri),length(Pts));
    fprintf(fid,'SCALARS scalars double\n');
    %if( ~isempty(LUT) )
    %      fprintf(fid, 'LOOKUP_TABLE myLUT\n');
    %else
    fprintf(fid, 'LOOKUP_TABLE default\n');
    %end
    fprintf(fid, '%f\n',Scalars);
    
end

if( ~isempty(Normals) )
    fprintf(fid,'\nCELL_DATA %d',length(Tri));
    fprintf(fid, '\nNORMALS Normals float\n');
    fprintf(fid,'%f %f %f\n',Normals.');
end

if( ~isempty(LUT) )
    fprintf(fid,'\nCELL_DATA %d\nPOINT_DATA %d\n',length(Tri),length(Pts));
%     fprintf(fid,'\nPOINT_DATA %d\n',length(Pts));
    fprintf(fid,'SCALARS Curvature float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');
    fprintf(fid,'%f\n',LUT);
end

if nargin>6
    if( ~isempty(Scalars2) )
    fprintf(fid,'\nCELL_DATA %d\n',length(Scalars2));
    fprintf(fid,'SCALARS segment int 1\n');
    fprintf(fid,'LOOKUP_TABLE default\n');
    fprintf(fid,'%d\n',Scalars2);
    end
end

fclose(fid);

end
