function [vertexLM_on_OES, distance] = project_landmarks_on_OES_CervixPlane( vertexEDJ, triangleEDJ, vertexOES, vertexLM,name)



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


a = coef(1)
b = coef(2)
d = coef(3)
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

n = cross(AC,AB)'
n = n/norm(n);

d = sum(M' .* n);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Projection of landmarks on the enamel %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = vertexLM(:,1);
B = vertexLM(:,2);
C = vertexLM(:,3);
D = vertexLM(:,4);

if option
	E = vertexLM(:,5);
end


vertexLM_on_OES = vertexLM;

Ta = (vertexOES - repmat(A,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
Tb = (vertexOES - repmat(B,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
Tc = (vertexOES - repmat(C,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
Td = (vertexOES - repmat(D,1,nb_vertices)) ./ repmat(n,1,nb_vertices);

Ia = find(Ta>0);
Ta(Ia) = Inf;

Ib = find(Tb>0);
Tb(Ib) = Inf;

Ic = find(Tc>0);
Tc(Ic) = Inf;

Id = find(Td>0);
Td(Id) = Inf;

[Ta,Ia] = min(minusPerLines(Ta))
[Tb,Ib] = min(minusPerLines(Tb));
[Tc,Ic] = min(minusPerLines(Tc));
[Td,Id] = min(minusPerLines(Td));

vertexLM_on_OES(:,1) = vertexOES(:,Ia);
vertexLM_on_OES(:,2) = vertexOES(:,Ib);
vertexLM_on_OES(:,3) = vertexOES(:,Ic);
vertexLM_on_OES(:,4) = vertexOES(:,Id);


if option
	Te = (vertexOES - repmat(E,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
	
	Ie = find(Te>0);
	Te(Ie) = Inf;
	
	[Te,Ie] = min(minusPerLines(Te));			
	vertexLM_on_OES(:,5) = vertexOES(:,Ie);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computation of distance between dentine and cervix plane %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

denominator = sqrt (n(1)^2 + n(2)^2 + n(3)^2);

VEDJ =  [vertexEDJ ; ones(1, size(vertexEDJ,2))];
coef = repmat([n(1) ; n(2) ; n(3) ; -d],1, size(vertexEDJ,2));

numerator = abs(sum(VEDJ .* coef, 1));

distance = numerator ./ denominator;




