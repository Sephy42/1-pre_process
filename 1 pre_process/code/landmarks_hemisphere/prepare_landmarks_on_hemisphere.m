function vertexLM_on_HS = prepare_landmarks_on_hemisphere(dim, vertexHS)

% Places landmarks on the hemisphere following the layout below. the larger dim, the larger the square form by the 4 landmarks.
% 
%    B  +----------+  C
%		|		   |
%		|	  	   |
%		|          |
%		|		   |
%    A  +----------+  D
%                   
%            +  E [opt]
%
% param : 
%	dim : float
%	vertexHS : mat D*N
% 	

% 2016 Margot Cantaloube




nb_vertices = size(vertexHS,2);
radius = compute_radius(vertexHS);

A = [ 0; -dim*radius; 0];
B = [ -dim*radius; 0; 0];
C = [ 0; dim*radius; 0];
D = [ dim*radius; 0; 0];
% option
E = [ dim*radius; -dim*radius; 0];

% normal vector of the plan
% n = [0;0;1];

% projection of the points on the hemisphere

[Ta,Ia] = min (sum (abs (vertexHS(1:2,:) - repmat(A(1:2,:),1,nb_vertices)) ) );
[Tb,Ib] = min (sum (abs (vertexHS(1:2,:) - repmat(B(1:2,:),1,nb_vertices)) ) );
[Tc,Ic] = min (sum (abs (vertexHS(1:2,:) - repmat(C(1:2,:),1,nb_vertices)) ) );
[Td,Id] = min (sum (abs (vertexHS(1:2,:) - repmat(D(1:2,:),1,nb_vertices)) ) );
% option
[Te,Ie] = min (sum (abs (vertexHS(1:2,:) - repmat(E(1:2,:),1,nb_vertices)) ) );


% rotation of an angle -pi/2

vertexLM_on_HS = zeros(3,5);

r = sqrt(2)/2;
Rot = [ r r 0 ; -r r 0 ; 0 0 1];

vertexLM_on_HS(:,1) = Rot * vertexHS(:,Ia);
vertexLM_on_HS(:,2) = Rot * vertexHS(:,Ib);
vertexLM_on_HS(:,3) = Rot * vertexHS(:,Ic);
vertexLM_on_HS(:,4) = Rot * vertexHS(:,Id);
% option

vertexLM_on_HS(:,5) = Rot * vertexHS(:,Ie);





