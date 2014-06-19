% Test script for generated hotel data
user = 500;
hotel = 30;
user_groups = 15;
groups = 8;
sparse = 0.5;
attack_groups = [1 3]; %[Number of groups   Number of hotel in attacking groups]
nil = -1;
t_elapsed = .0;
attackers_amount = [0:1:0];
%rand('seed', 42);

[ data, modData, g, attacker_rows ] = generateRealData( user, hotel, user_groups, groups, attackers_amount(end) ,sparse, attack_groups );
fprintf('Rank of data is %d\n', rank(data));

for attackers=1:length(attackers_amount);
    m = user + attackers_amount(attackers);

    %fprintf('ALM running on Matrix of size %d x %d\n',size(modData,1),size(modData,2));
		tic;
    predData_alm = alm_mc(modData(1:m,:), nil);
		t_elapsed = toc;
    %predData_alm = predData_alm(~ismember(1:m, attacker_rows), :);
    predData_alm_clean = predData_alm(1:user,:);

    mse_alm = sqrt(mean((data(:) - predData_alm_clean(:)).^2));
	fprintf(1,'%d\t\t%d\t\talm\n',attackers_amount(attackers),mse_alm);

    %fprintf('RPCA running on Matrix of size %d x %d\n',size(modData,1),size(modData,2));
	tic;
    [predData_rpca, noise_rpca] = rpca_missing(modData(1:m,:), nil);
	t_elapsed = toc;

    % Uncomment line to display attacker rows:
    % attacker_rows

    % Uncomment line to display noise:
    % noise_rpca

    %predData_rpca = predData_rpca(~ismember(1:m, attacker_rows), :);
    predData_rpca_clean = predData_rpca(1:user,:);

    mse_rpca = sqrt(mean((data(:) - predData_rpca_clean(:)).^2));
    fprintf(1,'%d\t\t%d\t\trpca\n',attackers_amount(attackers),mse_rpca);
        
    tic;
    predData_svd = baseline_svd(modData(1:m,:), nil);
	t_elapsed = toc;
    predData_svd_clean = predData_svd(1:user,:);
    mse_svd = sqrt(mean((data(:) - predData_svd_clean(:)).^2));
    fprintf(1,'%d\t\t%d\t\tsvd\n',attackers_amount(attackers),mse_svd);
end
