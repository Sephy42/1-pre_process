function vertexLM_on_OES = project_landmarks_on_OES( vertexOES, vertexLM)
 

nb_vertices = size(vertexOES,2);
nb_lm = size(vertexLM,2);


if (nb_lm == 5)
	option = 1;
else 
	option = 0;
end


A = vertexLM(:,1);
B = vertexLM(:,2);
C = vertexLM(:,3);
D = vertexLM(:,4);

if option
	E = vertexLM(:,5);
end


% keep the the three most relevant landmarks (the first ones) to create the plane
%  normal vector of the plane
AB = B - A;
AC = C - A;
n = cross(AC,AB);
n = n/norm(n);


vertexLM_on_OES = vertexLM;

Ta = (vertexOES - repmat(A,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
Tb = (vertexOES - repmat(B,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
Tc = (vertexOES - repmat(C,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
Td = (vertexOES - repmat(D,1,nb_vertices)) ./ repmat(n,1,nb_vertices);

[Ta,Ia] = min(minusPerLines(Ta));
[Tb,Ib] = min(minusPerLines(Tb));
[Tc,Ic] = min(minusPerLines(Tc));
[Td,Id] = min(minusPerLines(Td));

vertexLM_on_OES(:,1) = vertexOES(:,Ia);
vertexLM_on_OES(:,2) = vertexOES(:,Ib);
vertexLM_on_OES(:,3) = vertexOES(:,Ic);
vertexLM_on_OES(:,4) = vertexOES(:,Id);


if option
	Te = (vertexOES - repmat(E,1,nb_vertices)) ./ repmat(n,1,nb_vertices);
	[Te,Ie] = min(minusPerLines(Te));	
	vertexLM_on_OES(:,5) = vertexOES(:,Ie);
end



 
 
 
 
 
 
 
 
 
 
 
 
 
