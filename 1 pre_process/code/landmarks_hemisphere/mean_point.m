function centroid = mean_point(mat);

% mat must be N*Dimension
% return the mean point (centroid) of a set of point

% 2016 Margot Cantaloube


[N,D] = size(mat);

centroid = sum(mat) / N;



