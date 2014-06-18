% Test script for generated hotel data
user = 909;
hotel = 42;
groups = 5;
%attackers = 5;
sparse = 0.4;
nil = -1;
t_elapsed = .0;

for attackers=0:50:250
    m = user + attackers;

    [ data, modData, g, attacker_rows ] = generateGoodData( user, hotel, groups, attackers ,sparse );


    fprintf('ALM running on Matrix of size %d x %d\n',size(modData,1),size(modData,2));
		tic;
    predData_alm = alm_mc(modData, nil);
		t_elapsed = toc;
    %predData_alm = predData_alm(~ismember(1:m, attacker_rows), :);
    predData_alm_clean = predData_alm(1:user,:);

    mse_alm = sqrt(mean((data(:) - predData_alm_clean(:)).^2));
		fprintf(1,'ALM-Error with %d attackers: %f (runtime: %f sec.)\n', attackers, ...
			mse_alm, t_elapsed);

    fprintf('RPCA running on Matrix of size %d x %d\n',size(modData,1),size(modData,2));
		tic;
    [predData_rpca, noise_rpca] = rpca_missing(modData, nil);
		t_elapsed = toc;

    % Uncomment line to display attacker rows:
    % attacker_rows

    % Uncomment line to display noise:
    % noise_rpca

    %predData_rpca = predData_rpca(~ismember(1:m, attacker_rows), :);
    predData_rpca_clean = predData_rpca(1:user,:);

    mse_rpca = sqrt(mean((data(:) - predData_rpca_clean(:)).^2));
    fprintf(1,'RPCA-Error with %d attackers: %f (runtime: %f sec.)\n', ...
			attackers, mse_rpca, t_elapsed);
end
