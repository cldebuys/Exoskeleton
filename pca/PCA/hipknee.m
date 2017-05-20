close all

%JntAng=[KneeLAng KneeRAng HipLRAng HipRAng TorsoAng];
% k = 105;
k = 35;
start = 0;
angle_data = load('JntAngS01_TRIAL_06');
% data1 = [KneeLAng HipLRAng]
data1 = angle_data.JntAngS01_TRIAL_06((1 + start):(k + start),[1 3]);
% jointsRight = angle_data.JntAngS01_TRIAL_06(1:105,[2 4]);

% subtract the mean of each column from the data
data_no_mean = data1-repmat(mean(data1),size(data1,1),1);
[nt,pt] = size(data1);
S = std(data1);
Srep = repmat(S,size(data1,1),1);
data = data1./Srep;
data_norm = data_no_mean./Srep;

[coeff,score,latent,tsquared,explained,mu] = pca(data1);

Pt = coeff;
Xt = data_norm;
Yt = Xt*Pt;

%Obtaining normalized principle comp without matlab function
Sxt = (1/(nt-1))*transpose(Xt)*Xt;
Syt = (1/(nt-1))*transpose(Yt)*Yt;
R = Sxt./(max(max(abs(Sxt))));                   %Sxt_normalized
[V,D] = eig(R);

Pt_new = Pt(:,1);
Pt_new = V(:,2);
P_new = Pt_new';
Y_new = P_new*Xt';              % 3 by n
Yt_new = Y_new';
X_new = pinv(P_new)*Y_new;      % p by n
Xt_new = X_new';                % n by p

% Mult by Stdev and add mean back
data1_new = Xt_new.*Srep - (data_no_mean - data1);

gait = linspace(0 + start, 100*(k/105 + start/105), k)';
% swing and then stance
for i = 1:2
    figure(i);
    plot (gait,data1(:,i),'k')
    hold on
    plot (gait,data1_new(:,i),'g')
    xlabel('Gait Percentage')
    ylabel('Degrees')
end

Pt_new = Pt(:,2);
Pt_new = V(:,1);
P_new = Pt_new';
Y_new = P_new*Xt';              % 3 by n
Yt_new = Y_new';
X_new = pinv(P_new)*Y_new;      % p by n
Xt_new = X_new';                % n by p

% Mult by Stdev and add mean back
data1_new = Xt_new.*Srep - (data_no_mean - data1);

for i = 1:2
    figure(i+2);
    plot (gait,data1(:,i),'k')
    hold on
    plot (gait,data1_new(:,i),'r')
    xlabel('Gait Percentage')
    ylabel('Degrees')
end

knee = data1(:,1);
hip = data1(:,2);
% force_data = load('S01_TRIAL_06_force');
%     Force = force_data.ElevAngS01_TRIAL_06_force(1:105,[4 6]);
figure(5)
plot(gait,knee(:,1),'k',gait,hip(:,1),'b',100*[53/105 53/105],[-30 70],'r')
xlabel('Gait Percentage')
ylabel('Degrees')