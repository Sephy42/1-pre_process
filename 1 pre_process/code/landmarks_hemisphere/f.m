function dist = f(X, Y, s)

% 2016 Margot Cantaloube


X_prime = Y * s ;
dist = sum (distance(X,X_prime));
