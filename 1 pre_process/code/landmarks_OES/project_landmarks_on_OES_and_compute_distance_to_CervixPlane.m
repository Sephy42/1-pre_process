function [vertexLM_on_OES, distance2cervix] = project_landmarks_on_OES_and_compute_distance_to_CervixPlane( vertexEDJ, triangleEDJ, vertexOES, vertexLM)


% usage [vertexLM_on_OES, distance2cervix] = project_landmarks_on_OES_and_compute_distance_to_CervixPlane( vertexEDJ, triangleEDJ, vertexOES, vertexLM)
% param : 
%		* vertexEDJ : mat 3xN => vertices of dentine surface
%		* vertexOES : mat 3xN => vertices of enamel surface
%		* triangleEDJ : mat 3xN => topology of dentine vertices
%		* vertexLM : mat 3xN => vertices of Landmarks placed on dentine
%
% out :
%		* vertexLM_on_OES : mat 3xN => vertices of Landmarks projected on enamel
%		* distance2cervix : vector 1xN => distances of each point of vertexEDJ to the cervix plane



% 2016 Margot Cantaloube


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nb_vertices = size(vertexOES,2);
nb_lm = size(vertexLM,2);


if (nb_lm == 5)
	option = 1;
else 
	option = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% computation of the cervix plane %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boundaries = vertexEDJ(:,compute_boundary(triangleEDJ));
X = boundaries(1,:)';
Y = boundaries(2,:)';
Z = boundaries(3,:)';

const = ones(size(X));

coef = [X Y const]\Z;


a = coef(1);
b = coef(2);
d = coef(3);
c = 1;


xx = [0 1 2 3]';
yy = [0 1 0 0]';
zz = ( a*xx + b*yy + d );
mat = [xx yy zz];

A = mat(1,:);
B = mat(2,:);
C = mat(3,:);
M = mat(4,:);

AM = M - A;

AB = B - A;
AC = C - A;

n = cross(AC,AB)';
n = n/norm(n);

d = sum(M' .* n);


%%% display %%%
xout1 = n(1) * (-14000);
yout1 = n(2) * (-1500);
zout1 = - (xout1 + yout1 + d) / n(3);

xout2 = n(1) * (10000);
yout2 = n(2) * (-1500);
zout2 = - (xout2 + yout2 + d) / n(3);

xout3 = n(1) * (-14000);
yout3 = n(2) * (1000);
zout3 = - (xout3 + yout3 + d) / n(3);

xout4 = n(1) * (10000);
yout4 = n(2) * (1000);
zout4 = - (xout4 + yout4 + d) / n(3);

%pointout = [xout1 yout1 zout1 ; xout2 yout2 zout2 ; xout3 yout3 zout3 ; xout4 yout4 zout4];
%Write_vtk_surface(V_oes{k}', T_oes{k}', [], [], [], 'unplan.vtk'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Projection of landmarks on the enamel %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


vertexLM_on_OES = vertexLM;

denom = n(1)^2 + n(2)^2 + n(3)^2;



for (k = 1:nb_lm)

	% computation of the parameter t 
	
	A = vertexLM(:,k);	
	Axn = repmat(sum(A .* n, 1),1,nb_vertices);
	nxOES = sum(repmat(n,1,nb_vertices) .* vertexOES ,1);
	
	
	t = ( nxOES - Axn) ./ denom;
	
	% computation of the projection of each point of the enamel surface on the straight that pass by the point A and has n as director vector
	h = repmat(A,1,nb_vertices) + (repmat(t,3,1) .* repmat(n,1,nb_vertices));
	
	
	% computation of distance between each point and his projection h on the straight
	dist = distance(vertexOES, h);
	
	% ensure to take a point "above" the landmarks and do not project on the cervix for exemple
	index = find(t>0);
	dist(index) = Inf;
	
	% keep the closest point of the straight that is above the landmarks
	[dist_min,index] = min(dist);
	
	vertexLM_on_OES(:,k) = vertexOES(:,index);
	
end
	
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computation of distance between dentine and cervix plane %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

denominator = sqrt (n(1)^2 + n(2)^2 + n(3)^2);

VEDJ =  [vertexEDJ ; ones(1, size(vertexEDJ,2))];
coef = repmat([n(1) ; n(2) ; n(3) ; -d],1, size(vertexEDJ,2));

numerator = abs(sum(VEDJ .* coef, 1));

distance2cervix = numerator ./ denominator;




