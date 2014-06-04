function X_svd_shrunk = svd_threshold(X, t)

[U, S, V] = svd(X, 'econ');

S_shrunk = component_threshold(S, t);

X_svd_shrunk = U*S_shrunk*V';


end

