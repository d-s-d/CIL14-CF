m = 50; n = 100; d = 5; r = {};
for i = (1:d)
r{i} = rand(1, n);
end
% create M: toy matrix with rank d and 5% noise
M = zeros(m,n);
for i = (1:m)
M(i,:) = r{floor(rand*d+1)};
end
M = M - mean(M(:));
noise = sign(rand(m,n)-0.5);
noise = noise .* (rand(m,n)<0.05);
M = M + noise;
[ L S ] = rpca(M); % your function for RPCA
fprintf(1, 'rank(L) = %d', rank(L))
fprintf(1, 'nnz(S)/(m*n) = %d%%', round(100*nnz(S)/length(S(:))))
