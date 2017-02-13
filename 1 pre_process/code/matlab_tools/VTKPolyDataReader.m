function [Points, Tri, Normals, Scalars, LUT] = VTKPolyDataReader(filename)

% Usage:
% [Points, Tri, Normals. Scalars, LUT] = VTKPolyDataReader(filename)

% Output:
Points = [];  % set of vertices
Tri = [];     % set of triangles
Normals = []; % set of normals
Scalars = []; % set of scalars
LUT = [];     % LOOKUP Table

fid = fopen(filename, 'r');
if(fid==-1)
% % %     fprintf(1,'Error: file descriptor not valid, check the file name.\n');
% % %     return;
    error('Error: file descriptor not valid, check the file name.\n');
end


keyWord = 'DATASET POLYDATA';
newL = GoToKeyWord(fid, keyWord);
if(newL == -1)
% % %     fprintf(1, 'Error: file is not a vtkPolyData.\n');
% % %     return;
    error('Error: file is not a vtkPolyData.\n');
end





newL = fgetl(fid);
keyWord = 'POINTS';
newL = GoToKeyWord(fid, keyWord);
if(newL==-1)
    fprintf(1, 'Cannot find flag: %s\n', keyWord);
end

buffer = sscanf(newL,'%s%d%s');
numPoints = buffer(length(keyWord)+1); % because these are points


Points = fscanf(fid,'%f',[3 numPoints]).';
% newL = fgetl(fid);
% count = 1;
% 
% % Read the points data
% while(count<=3*numPoints)
%     [num,c] = sscanf(newL,'%f');
%     Points = [Points;num];
%     
%     count = count + c;
%     newL = fgetl(fid);
% end
% Points = reshape(Points, [3,numPoints])';
% % end of point data


if nargout>1
% Read the polygons
keyWord = 'POLYGONS';
newL = GoToKeyWord(fid, keyWord);
if(newL == -1)
    return;
end
buffer = sscanf(newL, '%s%d%d');
numPoly = buffer(length(keyWord)+1); % get the number of polygons
numTotal = buffer(length(keyWord)+2); % get the actual number of things to read


Tri = fscanf(fid,'%d',[4 numTotal]).'+1;
Tri = Tri(:,2:4);

% % Tri = zeros(numPoly,3);
% % 
% % for i=1:numPoly
% %     newL = fgetl(fid);
% %     buffer = sscanf(newL, '%d %d %d %d'); % only triangles are supported
% %     
% %     Tri(i,:) = buffer(2:4)';
% %         
% % end
% % Tri = Tri+1; % problem with index in matlab / c
% % % end of polygons
% 
if nargout>2
keyWord = 'CELL_DATA';
newL = GoToKeyWord(fid, keyWord);
if(newL == -1)
    return
end
buffer = sscanf(newL, '%s%d');
numCellData = buffer(length(keyWord)+1);

keyWord = 'NORMALS';
newL = GoToKeyWord(fid, keyWord);
if(newL == -1)
    fprintf(1, 'No normal data\n');
else
      
    count = 1;
    while(count <= 3*numCellData)
        
        newL = fgetl(fid);
        [buffer,c] = sscanf(newL, '%f');
        count = count+c;
        Normals = [Normals; buffer];
        
    end
    
    Normals = reshape(Normals, [3, numCellData])';
    
    
end
% 
% keyWord = 'POINT_DATA';
% newL = GoToKeyWord(fid, keyWord);
% if(newL ==-1)
%     return;
% end
% buffer = sscanf(newL,'%s%d');
% numPointData = buffer(length(keyWord)+1);
% 
% 
% 

%Read the scalars
keyWord = 'SCALARS';
[newL Line] = GoToKeyWord(fid, keyWord);

if(newL == -1)
    fprintf(1, 'No scalar\n');
else
    fid2 = fopen(filename, 'r');
    C = textscan(fid2, '%s', 1, 'delimiter', '\n', 'headerlines', Line-2);
    fclose(fid2);
    numScalar = sscanf(C{1}{1},'%*s %d');
    keyWord = 'LOOKUP_TABLE';
    newL = GoToKeyWord(fid, keyWord);
    if(newL == -1)
        fprintf(1, 'No LUT\n');
        keyWord = 'SCALARS';
        newL = GoToKeyWord(fid, keyWord);
    end
    
    count = 1;
    while(count <= numScalar)
        
        newL = fgetl(fid);
        [buffer, c] = sscanf(newL, '%f');
        count = count + c;
        Scalars = [Scalars;buffer];
        
    end
    
end
%end of scalars
end
end

% 
% 
% 
% % Read the LUT: supposed to be right after the scalars!!
% % keyWord = 'LOOKUP_TABLE';
% % while(strncmp(newL, keyWord, length(keyWord))==0 & newL~=-1)
% %     newL = fgetl(fid);
% % end
% % if(newL == -1)
% %     fprintf(1,'There is no LUT.\n');
% % else
% %     
% %     buffer = sscanf(newL, '%s%s%d');
% %     numLUT = buffer(end);
% %     
% %     count = 1;
% %     while(count <= 4*numLUT)
% %         
% %         newL = fgetl(fid);
% %         [buffer, c] = sscanf(newL, '%f');
% %         count = count + c;
% %         LUT = [LUT; buffer];
% %         
% %     end
% %    
% %     LUT = reshape(LUT, [4,numLUT])';
% %     
% % end
% 
% % end of LUT
% 
% 
% % read the normals
% % end of normals

fclose(fid);