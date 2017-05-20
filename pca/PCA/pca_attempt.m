%ElevAng=[ThighLAng ThighRAng ShankLAng ShankRAng TorsoAng FootLAng FootRAng];

%JntAng=[KneeLAng KneeRAng HipLRAng HipRAng TorsoAng];

% % % knee = shank - thigh  
% % % hip = torso - thigh 
% % % ankle = comp(shank) + shank + footfromhorz
% % % ankle = (90 - shank) + shank + (foot - 90) = foot

%~~~~~Actual Code Begins Here~~~~~%
Shanks = ElevAngS01_TRIAL_06(:,[3 4]);
Joints = JntAngS01_TRIAL_06(:,1:4);
Ankles = ElevAngS01_TRIAL_06(:,6:7);
figure(4)
plot(90 - ElevAngS01_TRIAL_06(:,4))
% data1 = [KneeLAng KneeRAng HipLRAng HipRAng FootLAng FootRAng]
data1 = [Joints Ankles];
data1 = data1(:,2:2:6);        %unsilence for left leg only
% subtract the mean of each column from the data
data_no_mean = data1-repmat(mean(data1),size(data1,1),1);
[nt,pt] = size(data1);
S = std(data1);
Srep = repmat(S,size(data1,1),1);
data = data1./Srep;
data_norm = data_no_mean./Srep;



% columns of coeff are the principle components
[coeff,score,latent,tsquared,explained,mu] = pca(data1)
% % Weighted PCA
% [coeff,score,latent,tsquared,explained,mu] = pca(Sx);

Pt = coeff;
Xt = data_norm;
Yt = Xt*Pt;

% rows of P are the principle components
P = transpose(coeff);       % p by p
eig(P);
X = transpose(data_norm);   % p by n
Y = P*X;                    % p by n

%corelation matrix
cov = (1/(nt-1))*transpose(data_no_mean)*data_no_mean
[V_cov,D_cov] = eig(cov)

%Obtaining normalized principle comp without matlab function
Sxt = (1/(nt-1))*transpose(Xt)*Xt;
Syt = (1/(nt-1))*Y*Yt;
R = Sxt./(max(max(abs(Sxt))));                   %Sxt_normalized
[V,D] = eig(R)

% Sx = (1/(n-1))*Xt*transpose(Xt);        % p by p
% Sy = (1/(n-1))*Yt*transpose(Yt);        % p by p



%if only the first 3 of 6 (or 2 of 3) components matter
% P_new = P(1:3,:);            % 3 by p
P_new = transpose(Pt(:,1:2));
P_new = transpose(V(:,2:3))        %set new P matrix
%P_new = [0 1 0; 0.66929 0 0.74300]
Y_new = P_new*X;             % 3 by n
Yt_new = transpose(Y_new);

X_new = pinv(P_new)*Y_new;      % p by n
                                % this is only one solution of many
Xt_new = transpose(X_new);      % n by p
% E = Xt_new - data_norm;         % error between new data and original data
% max_error = max(abs(E));        % maximum error of each parameter
% avg_error = mean(abs(E));       % average error of each parameter
% avg_percent_error = 100*avg_error./(range(data)); 
% 
% % these last 2 are not good measures at the small data points
% error_percent = E./((data));                    
% avg_error_percent = mean(abs(error_percent));

for i = 1:1:3
    figure(i);
    plot (Xt(:,i),'-')
    hold on
    plot (Xt_new(:,i),'--')
    xlabel('Samples')
    ylabel('Degrees')
end