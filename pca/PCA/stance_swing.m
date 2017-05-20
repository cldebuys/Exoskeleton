% manipulates left-right leg data to be in stance-swing format

Joints = JntAngS01_TRIAL_06(:,1:4);
Ankles = ElevAngS01_TRIAL_06(:,6:7);
% data1 = [KneeLAng KneeRAng HipLRAng HipRAng FootLAng FootRAng]
% data1 = [Joints Ankles];

% Averaging the data (2 left and 2 right for each column below)

kneeSwing = mean(horzcat(Joints(1:52,1),Joints(53:104,2),Joints(105:156,1),Joints(157:208,2)),2);
kneeStance = mean(horzcat(Joints(1:52,2),Joints(53:104,1),Joints(105:156,2),Joints(157:208,1)),2);

hipSwing = mean(horzcat(Joints(1:52,3),Joints(53:104,4),Joints(105:156,3),Joints(157:208,4)),2);
hipStance = mean(horzcat(Joints(1:52,4),Joints(53:104,3),Joints(105:156,4),Joints(157:208,3)),2);

ankleSwing = mean(horzcat(Ankles(1:52,1),Ankles(53:104,2),Ankles(105:156,1),Ankles(157:208,2)),2);
ankleStance = mean(horzcat(Ankles(1:52,2),Ankles(53:104,1),Ankles(105:156,2),Ankles(157:208,1)),2);


% New data set in terms of stance and swing

data1 = [kneeSwing kneeStance hipSwing hipStance ankleSwing ankleStance];


% Uncomment line below to look at only stance or swing
% data1 = [kneeSwing hipSwing ankleSwing ];
% disp('Swing Phase')
data1 = [kneeStance hipStance ankleStance];
disp('Stance Phase')

% PCA using new data
data_no_mean = data1-repmat(mean(data1),size(data1,1),1);       % remove the mean of the data
[nt,pt] = size(data1);                                          % data dimensions
S = std(data1);                                                 % standard deviation
Srep = repmat(S,size(data1,1),1);
data = data1./Srep;                                             
data_norm = data_no_mean./Srep;                                 % normalize data w.r.t. standard deviation
Xt = data_norm;


%Obtaining normalized principle comp without matlab function
Sxt = (1/(nt-1))*transpose(Xt)*Xt;
R = Sxt./(max(max(abs(Sxt))));                   %Sxt_normalized
[V,D] = eig(R)

%if only the first 3 of 6 (or 2 of 3) components matter
Pt_new = V(:,2:3);         % set new P matrix

Yt_new = Xt*Pt_new;
                                    % this is only one solution of many
Xt_new = Yt_new*pinv(Pt_new);          % n by p

for i = 1:1:pt
    figure(i);
    plot (Xt(:,i),'-')
    hold on
    plot (Xt_new(:,i),'--')
    xlabel('Samples')
    ylabel('Degrees')
end