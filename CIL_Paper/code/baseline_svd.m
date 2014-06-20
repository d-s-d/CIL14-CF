function L = baseline_svd(M, nil)
% Simple SVD for matrix completion that uses
% a mean for each user as starting point for the
% missing values

m = size(M, 1);

user_means = zeros(m,1);
for i=1:m
    user_means(i) = mean(M(i, M(i,:) ~= nil));
    M(i,M(i,:) == nil) = user_means(i);
end

k = 6;

[U_k, D_k, V_k] = svds(M, k);

L = U_k*D_k*V_k';

end

