function [ R, s, ty, tx, new_X, new_Y] = rigid (X,Y)

% usage [ R, s, ty, tx, new_X, new_Y] = rigid (X,Y)
%	Do the rigid registration of Y on centered X. 
%	new_Y = (ty + Y) * R * s.
%	new_X is centered X (centroid in [0,0,0]). new_X = tx + X.

% this code is a simplified version of the CDP_RIGID program => Copyright (C) 2008 Andriy Myronenko (myron@csee.ogi.edu)
% written by Margot Cantaloube 2016


% Initialization
X = X';
Y = Y';

[N, D]=size(X);
[M, D]=size(Y);

% number of landmarks to be considered in the computation
nb_lm = M;

if nb_lm > 4
	nb_lm = 4;
end 


% computation of the translation to center the data

X_mean = mean_point(X(1:nb_lm,:));
tx = -X_mean;
X = X + repmat(tx, N, 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% translation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% computation of the translation to center the data

Y_mean = mean_point(Y(1:nb_lm,:));	
ty = -Y_mean;

% centering of the data

Y = Y + repmat(ty, M, 1);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% rotation %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


A = X(1:nb_lm,:)' * Y(1:nb_lm,:);   
[U,S,V]=svd(A);

R=U*V';


% avoid reflection effect
if (det(R) < 0)
 R(3,:) = R(3,:) * (-1);
end

Y = R * Y';
Y = Y';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% scaling %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



distX = distance(X(1,:)', X(2,:)');
distY = distance(Y(1,:)', Y(2,:)');
s0 = distX/distY;

s = fminsearch(@(s0) f(X(1:nb_lm,:),Y(1:nb_lm,:),s0),s0);

Y = Y * s;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

new_Y = Y';
new_X = X';






