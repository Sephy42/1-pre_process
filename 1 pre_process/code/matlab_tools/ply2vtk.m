function ply2vtk(filenamein,filenameout)

fid = fopen(filenamein,'r');
flag = false;
for k=1:15
    tline = fgetl(fid);
    if ~isempty(strfind(tline, 'element face'))
        if sscanf(tline,'%*s %*s %d')>64536
            [Tri Pts] = ply_read_faceUINT32(filenamein,'tri');
        else
            [Tri Pts] = ply_read(filenamein,'tri');
        end
        flag=true;
        break
    end
end
fclose(fid);

if flag == false
    error('Impossible de lire le nombre de faces');
end

Scalars = ones(1,size(Pts,2));


Write_vtk_surface(Pts', Tri', [], Scalars, [], filenameout);