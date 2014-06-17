% Test script for generated hotel data
user = 500;
hotel = 40;
groups = 5;
attackers = 5;
sparse = 0.4;
nil = -1;

m = user + attackers;

[ data, modData, g, attacker_rows ] = generateDifferentData( user, hotel, groups, attackers ,sparse );


predData_alm = alm_mc(modData, nil);
predData_alm = predData_alm(~ismember(1:m, attacker_rows), :);

mse_alm = sqrt(mean((data(:) - predData_alm(:)).^2))

[predData_rpca, noise_rpca] = rpca_missing(modData, nil);

% Uncomment line to display attacker rows:
% attacker_rows

% Uncomment line to display noise:
% noise_rpca

predData_rpca = predData_rpca(~ismember(1:m, attacker_rows), :);

mse_rpca = sqrt(mean((data(:) - predData_rpca(:)).^2))