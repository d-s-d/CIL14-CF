% Test script for generated hotel data
user = 999;
hotel = 42;
user_groups = 6;
groups = 5;
sparse = 0.5;
attack_groups = [1 3]; %[Number of groups   Number of hotel in attacking groups]
nil = -1;
t_elapsed = .0;
attackers_amount = [0:100:500];

rand('seed', 42);

[ data, modData, g, attacker_rows ] = generateRealData( user, hotel, user_groups, groups, attackers_amount(end) ,sparse, attack_groups );

%M = zeros(user,hotel);
%user_means = zeros(user,1);
%for i=1:user
%    user_means(i) = mean(modData(i, modData(i,:) ~= nil));
%    M(i,M(i,:) == nil) = user_means(i);
%end

fprintf('Attackers\t\talm\t\trpca\t\tsvd\n');

for attackers=1:length(attackers_amount)
    %fprintf('%d user groups:\n',user_groups);

    %fprintf('Rank of data is %d\n', rank(data));
%for sparse = 0.3:0.1:0.8
 %   modData = fullmodData;
  %  idx = randperm(numel(data));
   % corrVal = round(sparse * numel(data));
    %for j=1:corrVal
     %   modData(idx(j)) = -1;
    %end
    
    m = user + attackers_amount(attackers);

    %fprintf('ALM running on Matrix of size %d x %d\n',size(modData,1),size(modData,2));
		tic;
    predData_alm = alm_mc(modData(1:m,:), nil);
		t_elapsed = toc;
    %predData_alm = predData_alm(~ismember(1:m, attacker_rows), :);
    predData_alm_clean = predData_alm(1:user,:);

    mse_alm = sqrt(mean((data(:) - predData_alm_clean(:)).^2));
	%fprintf(1,'%d\t\t%d\t\talm\n',sparse,mse_alm);

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
    %fprintf(1,'%d\t\t%d\t\trpca\n',sparse,mse_rpca);
        
    tic;
    predData_svd = baseline_svd(modData(1:m,:), nil);
	t_elapsed = toc;
    predData_svd_clean = predData_svd(1:user,:);
    mse_svd = sqrt(mean((data(:) - predData_svd_clean(:)).^2));
    fprintf(1,'%d\t\t%d\t\t%d\t\t%d\n',attackers_amount(attackers),mse_alm,mse_rpca,mse_svd);
    
    %mse_rand = sqrt(mean((data(:) - M(:)).^2));
    %fprintf(1,'%d\t\t%d\t\tmean\n',attackers_amount(attackers),mse_rand);
end
%end