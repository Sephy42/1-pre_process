function [distance] = distance (m1,m2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the distance point to point between m1 and m2					   				   %
% param : m1, m2 => 3*n matrices of the coordinates of the vertices of the two surfaces.   %	
% out : distance => 1*n vector of the distances point to point from m1 to m2. 		   	   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2016 Margot Cantaloube


if (size(m1) ~= size(m2) ) 
	print ('matrices must have the same dimensions');
	exit;
end

distance =  sqrt( sum( (m1-m2).^2 ) );









