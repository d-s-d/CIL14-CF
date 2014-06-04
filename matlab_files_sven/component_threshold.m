function shrunk_X = component_threshold(X, t)
%Component-wise threshold of matrix X with threshold t

shrunk_X = sign(X) .* max(abs(X) - t, 0);




end

