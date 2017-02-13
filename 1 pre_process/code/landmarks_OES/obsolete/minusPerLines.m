function out = minusPerLine(mat)

% return the vector 1xn of the sums of the differences line per line of mat (3xn).

% written by Margot Cantaloube 2016

x = mat(1,:);
y = mat(2,:);
z = mat(3,:);

out = abs(x - y) + abs(x - z) + abs(y - z);

