function [ data, modData, g, attacker_rows ] = generateData( user, hotel, groups, attackers ,sparse )
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

data = zeros(user,hotel);

%Objective Hotel Quality
hotel_quality = rand(hotel,1);

%Gorup hotels
col_permuted = randperm(hotel);
for k=1:groups
    g{k} = col_permuted(k);
end
for k=(groups+1):hotel
    g{ceil(groups*rand)}(1,end+1) = col_permuted(k);
end

%Introduce group coupling (similarity)
group_coupling = eye(groups);
group_coupling(1,2:groups) = rand(1,groups-1);
for k=2:groups
    for l=(k+1):groups
        group_coupling(k,l) = (1-abs(group_coupling(1,k)-group_coupling(1,l)))*0.8 + 0.2*rand;
    end
end
group_coupling = group_coupling + triu(group_coupling,1)';

%generate full rankings based on user-group ranking and group coupling
user_group_rating = rand(user,groups);
for i=1:user
    for t=2:groups
       user_group_rating(:,t) = max(0,min(1,(mean(user_group_rating(:,1:(t-1)) + sign(rand(user,t-1)-0.5).*repmat((1-group_coupling(t,1:(t-1))),user,1).*(rand(user,t-1)./t),2))));
    end
end
for h=1:hotel
    for find_group=1:groups
        if ismember(h,g{find_group})
            hotel_group = find_group;
            break;
        end
    end
    data(:,h) = max(0,min(100,round(80*user_group_rating(:,hotel_group) + 20*repmat(hotel_quality(h),user,1))));
    %data(:,h) = max(0,min(100,round(random('norm',100*rand,5+10*rand,user,1))));
end

%initialize modified Data
modData = data;

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
    permutation = randperm(size(modData,1));
    attacker_rows = find(permutation > user);
    modData = modData(permutation,:);
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

