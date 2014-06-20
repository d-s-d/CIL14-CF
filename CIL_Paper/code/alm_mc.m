function L = alm_mc(M, nil)
% ALM method for matrix completion

m = size(M, 1);
n = size(M, 2);

S = zeros(m, n);
Y = zeros(m, n);

nil_values = (M == nil);
M(nil_values) = 0;

mu = 0.5/norm(sign(M));
mu_inv = 1/mu;

max_iter = 150;

[U_L, S_L, V_L] = svd(M - S + mu_inv*Y, 'econ');
shrunk_S_L = sign(S_L) .* max(abs(S_L) - mu_inv, 0);
L = U_L*shrunk_S_L*V_L';
S(nil_values) = M(nil_values) - L(nil_values) + mu_inv*Y(nil_values);
Y = Y + mu*(M - L - S);

iter = 0;
while(norm(M - L - S, 'fro')/norm(M, 'fro') > 1e-7 && iter < max_iter)
[U_L, S_L, V_L] = svd(M - S + mu_inv*Y, 'econ');
shrunk_S_L = sign(S_L) .* max(abs(S_L) - mu_inv, 0);
L = U_L*shrunk_S_L*V_L';
S(nil_values) = M(nil_values) - L(nil_values) + mu_inv*Y(nil_values);
Y = Y + mu*(M - L - S);
iter = iter + 1;
end

end

