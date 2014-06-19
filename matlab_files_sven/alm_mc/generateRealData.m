function [ data, modData, g, user_hotel_group_rating, group_coupling, user_group_rating ] = generateRealData(user,hotel,no_user_groups,groups,attackers,sparse,attack_groups)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

data = zeros(user,hotel);
attacker_rows = zeros(0);
%Objective Hotel Quality
hotel_quality = rand(hotel,1);

%Get attacking gorups
bad_hotels = randperm(hotel);
for bad=1:attack_groups(1)
    bad_groups{bad} = bad_hotels(bad:floor(attack_groups(2)/bad));
end

%Gorup hotels
col_permuted = randperm(hotel);
for k=1:groups
    g{k} = col_permuted(k);
end
for k=(groups+1):hotel
    g{ceil(groups*rand)}(1,end+1) = col_permuted(k);
end
%Group users
user_group = ceil(no_user_groups*rand(user,1));

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
user_hotel_group_rating = rand(no_user_groups,groups);
for t=2:groups
    user_hotel_group_rating(:,t) = max(0,min(1,(mean(user_hotel_group_rating(:,1:(t-1)) + sign(rand(no_user_groups,t-1)-0.5).*repmat((1-group_coupling(t,1:(t-1))),no_user_groups,1).*(rand(no_user_groups,t-1))./1,2))));
    %user_hotel_group_rating(:,t) = max(0,min(1,(mean(user_hotel_group_rating(:,1:(t-1)) + sign(rand(no_user_groups,t-1)-0.5).*repmat((1-group_coupling(t,1:(t-1))),no_user_groups,1),2) + sign(rand-.5)*rand/3 )));
end

user_group_rating = zeros(user,groups);
for p=1:user
   user_group_rating(p,:) = user_hotel_group_rating(user_group(p,1)); 
end

for h=1:hotel
    for find_group=1:groups
        if ismember(h,g{find_group})
            hotel_group = find_group;
            break;
        end
    end
    data(:,h) = max(0,min(100,round(60*(user_group_rating(:,hotel_group)+sign(rand(user,1)-0.5).*rand(user,1)/20) + 40*repmat(hotel_quality(h),user,1))));
    %data(:,h) = max(0,min(100,round(random('norm',100*rand,5+10*rand,user,1))));
end

%initialize modified Data
modData = data;

%Add Shilling attacks
if (attackers > 0)
    fake_data = zeros(attackers,hotel);
    for a=1:attackers
        attacking_group = ceil(attack_groups(1)*rand);
        for b=1:hotel
            if ismember(b,bad_groups{attacking_group})
                value = min(100,round(random('norm',980,2)));
            else
                value = max(0,round(random('norm',2,2)));
            end
            fake_data(a,b) = value;
        end
    end
    %Add attacks to data
    modData((end+1):(end+attackers),:) = fake_data;
        
    %Mix attackers into regular users
    %permutation = randperm(size(modData,1));
    %attacker_rows = find(permutation > user);
    %modData = modData(permutation,:);
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

