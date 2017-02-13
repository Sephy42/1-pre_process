function [pts2 tri2 mindist] = closestPoint(Filename1, Filename2)

[pts1, tri1] = VTKPolyDataReader(Filename1);
pts1 = pts1.';

[pts2, tri2] = VTKPolyDataReader(Filename2);
pts2 = pts2.';

tri1 = zeros(size(pts2,2),2);
tri1(:,1) = (1:size(pts2,2)).';

ptsClosestPoint = zeros(3,size(pts2,2)*2);
ptsClosestPoint(:,1:size(pts2,2)) = pts2;

m = size(pts2,2);
n = size(pts1,2);
match = zeros(1,m);
mindist = zeros(1,m);
for k=1:m
    d=zeros(1,n);
    for ti=1:3
        d=d+(pts1(ti,:)-pts2(ti,k)).^2;
    end
    d = sqrt(d);
    [mindist(k),match(k)]=min(d);
    ptsClosestPoint(:,size(pts2,2)+k) = pts1(:,match(k));
    tri1(k,2) = size(tri1,1)+k;
end

[pathstr,name,ext] = fileparts(Filename2);
%Write_vtk_surface(pts2.', tri2, [], mindist, [], fullfile('data_out/',sprintf('%s%s',name,'_closestPoint.vtk')));
