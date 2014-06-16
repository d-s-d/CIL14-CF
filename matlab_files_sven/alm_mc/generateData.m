function [ data, modData, g ] = generateData( user, hotel, groups, attackers ,sparse )
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

data = zeros(user,hotel);

%generate full rankings
for i=1:hotel
    data(:,i) = max(0,min(100,round(random('norm',100*rand,5+10*rand,user,1))));
end

%initialize modified Data
modData = data;

%Gorup hotels for later attacks
col_permuted = randperm(hotel);
for k=1:groups
    g{k} = col_permuted(k);
end
for k=(groups+1):hotel
    g{ceil(groups*rand)}(1,end+1) = col_permuted(k);
end

%Add Shilling attacks
if (attackers < user && attackers > 0)
    fake_data = zeros(attackers,hotel);
    for a=1:attackers
        attacking_group = ceil(groups*rand);
        for b=1:hotel
            if ismember(b,g{attacking_group})
                value = min(100,round(random('norm',98,2)));
            else
                value = max(0,round(random('norm',2,2)));
            end
            fake_data(a,b) = value;
        end
    end
    %Add attacks to data
    modData((end+1):(end+attackers),:) = fake_data;
    %Mix attackers into regular users
    modData = modData(randperm(size(modData,1)),:);
end

%Remove some vlaues according to sparse
if (sparse > 0 && sparse < 1)
    idx = randperm(numel(data));
    corrVal = round(sparse * numel(data));
    for j=1:corrVal
        modData(idx(j)) = -1;
    end
end

end

