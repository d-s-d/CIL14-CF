function [L , S] = rpca(M)
%Decompose M into L + S with L low-rank, S sparse
% Robust principal component analysis using ADMM
% For minimization of the functionals, we use thresholding
% In particular, singular value thresholding for L  

S = zeros(size(M));
Y = zeros(size(M));

% Not sure about mu
mu = 10;
mu_inv = 1/mu;

% This needs to be set for the algorithm to end right now
% The convergence criterion does not seem to be met ever
% using the toy data
max_iter = 100;

% According to the paper
lambda = 1/sqrt(size(M,1));

L = svd_threshold(M - S + mu_inv*Y, mu_inv);
S = component_threshold(M - L + mu_inv*Y, lambda*mu_inv);
Y = Y + mu*(M - L - S);

iter = 0;
while (norm(M - L - S, 'fro') / norm(M, 'fro') > eps && iter < max_iter )
L = svd_threshold(M - S + mu_inv*Y, mu_inv);
S = component_threshold(M - L + mu_inv*Y, lambda*mu_inv);
Y = Y + mu*(M - L - S);
iter = iter + 1;
end












end

