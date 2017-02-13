function []=Write_vtk_point(Pts,Normals,filename,Scalar)

% Usage:
% Write_vtk_surface(Pts, Tri, Normals, Scalars, LUT, filename);

  fid = fopen(filename, 'w');
  
  fprintf(fid, '# vtk DataFile Version 3.0\nvtk output\nASCII\n');
  
  fprintf(fid, 'DATASET POLYDATA\n');
  
  fprintf(fid, 'POINTS %d float\n',size(Pts,1));
  fprintf(fid, '%f %f %f\n',Pts.');
  fprintf(fid, 'VERTICES %d %d\n',size(Pts,1),size(Pts,1)*2);
  fprintf(fid, '%d %d\n',[ones(size(Pts,1),1) (0:size(Pts,1)-1).'].');
%   fprintf(fid, 'CELL_TYPES %d',size(Pts,1));
%   fprintf(fid, '%d\n',ones(size(Pts,1),1));
%   
  
  
  if( ~isempty(Normals) )
    fprintf(fid,'\nPOINT_DATA %d',size(Pts,1));
    fprintf(fid, '\nNORMALS Normals float\n');
    fprintf(fid,'%f %f %f\n',Normals.');
  end
  
  if( ~isempty(Scalar) )
    fprintf(fid,'\nCELL_DATA %d',size(Pts,1));
    fprintf(fid, '\nSCALARS cell_scalars int 1\nLOOKUP_TABLE default\n');
    fprintf(fid,'%d\n',Scalar);
  end

  fclose(fid);

end 