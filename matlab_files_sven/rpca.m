function [L , S] = rpca(M)
%Decompose M into L + S with L low-rank, S sparse
% Robust principal component analysis using ADMM
% For minimization of the functionals, we use thresholding
% In particular, singular value thresholding for L  

S = zeros(size(M));
Y = zeros(size(M));

% Not sure what this t should be exactly, it is only stated that t > 0
t = 100*eps;

% According to the paper
lambda = 1/sqrt(size(M,1));

L = svd_threshold(M - S + Y, t);
S = component_threshold(M - L + Y, lambda*t);
Y = Y + (M - L - S);

while (norm(M - L - S, 'fro') / norm(M, 'fro') > eps)
L = svd_threshold(M - S + Y, t);
S = component_threshold(M - L + Y, lambda*t);
Y = Y + (M - L - S);
end












end

