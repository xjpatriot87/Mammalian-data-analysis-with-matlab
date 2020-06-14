% i=1;
clear;
file_dir = '';% file dir
gfitc_RFP_ratio={};
id = [NaN, Inf, -Inf];
back_num = 3; % The variable back_num corresponds to the number of parallel control samples
sample_num = 60; % The variable sample_num corresponds to the number of total experimental samples
background_fitc = zeros(1,back_num); 
background_rfp = zeros(1,back_num);
mean_fitc = zeros(1,sample_num);
mean_rfp = zeros(1,sample_num);
std_fitc = zeros(1,sample_num);
std_rfp = zeros(1,sample_num);
num_event = zeros(1,sample_num);
mean_FITC_Ratio = zeros(1,sample_num); 
std_FITC_Ratio = zeros(1,sample_num);
% var_FITC_Ratio = zeros(1:20);

% From control samples get background fitc and RFP values
for j = 1:back_num % Depends on how many parallel samples you have
clear data;
clear params;
clear fitc;
clear fsc;
clear ssc;

filename=sprintf('b_%d.fcs',j); % Rename fcs files of control samples as b_1.fcs to b_4.fcs in advance
[data,params] = fcsread([file_dir filename]);

fsc=data(:,1);
ssc=data(:,2);
fitc_ORI=data(:,3);
RFP_ORI=data(:,4); % Depends on how your data is written in fcs file. Check the variable 'params' in workspace to find out.


% Compensation
fitc_comp = 0; %change to 0.1 for 10% compensation
RFP_comp = 0; %change to 0.1 for 10% compensation
fitc = fitc_ORI - fitc_comp * RFP_ORI;
RFP = RFP_ORI - RFP_comp * fitc_ORI;

% gate
g1 = or(or(fsc<50000,fsc>2600000), or(ssc<50000,ssc>2600000)); %background FSC and SSC gate parameter
gate1=find(g1==1);
ssc(gate1)=[];
fitc(gate1)=[];
fsc(gate1)=[];
RFP(gate1)=[];

gate2=find(RFP<=20);
ssc(gate2)=[];
fitc(gate2)=[];
fsc(gate2)=[];
RFP(gate2)=[];

gate3=find(fitc<=20);
ssc(gate3)=[];
fitc(gate3)=[];
fsc(gate3)=[];
RFP(gate3)=[];

background_fitc(j)=mean(fitc);
background_rfp(j)=mean(RFP);

end

% Remove NaN, Inf, -Inf
g4 = or(ismissing(background_fitc, id),ismissing(background_rfp,id));
gate4=find(g4==1);
background_fitc(gate4) = [];
background_rfp(gate4) = [];

% Get background fitc and gfp values
background_FITC = mean(background_fitc, 2); 
background_RFP = mean(background_rfp, 2);
   
for j= 1:sample_num % Depends on how many samples (fcs files) you have
clear data;
clear params;
clear fitc;
clear fsc;
clear ssc;

filename=sprintf('%d.fcs',j); % require previous renamed fcs files as 1.fcs to 20.fcs
[data,params] = fcsread([file_dir filename]);

% Extract original data
fsc=data(:,1);
ssc=data(:,2);
fitc_ORI=data(:,3);
RFP_ORI=data(:,4); % Depends on how your data is written in fcs file. Check the variable 'params' in workspace to find out.


% Compensation
fitc_comp = 0; %change to 0.1 for 10% compensation
RFP_comp = 0; %change to 0.1 for 10% compensation
ori_fitc = fitc_ORI - fitc_comp * RFP_ORI;
ori_RFP = RFP_ORI - RFP_comp * fitc_ORI;

% Omit invalid data
gate2=find(ori_RFP<=1000); %RFP threashold
ori_fitc(gate2)=[];
fsc(gate2)=[];
ori_RFP(gate2)=[];
ssc(gate2)=[];

gate3=find(ori_fitc<=20);
ori_fitc(gate3)=[];
fsc(gate3)=[];
ori_RFP(gate3)=[];
ssc(gate3)=[];

% Subtract background fitc and background rfp
fitc=ori_fitc - background_FITC;
RFP=ori_RFP - background_RFP;

% gate
g1 = or(or(fsc<50000,fsc>2600000), or(ssc<50000,ssc>2600000)); %FSC and SSC threashold
gate1=find(g1==1);
fitc(gate1)=[];
fsc(gate1)=[];
RFP(gate1)=[];

num_event(j)=length(fitc);
mean_fitc(j)=mean(fitc);
mean_rfp(j)= mean(RFP);
std_fitc(j)=std(fitc);
std_rfp(j)=std(RFP);

% Get the FITC/RFP ratio for each cell
original_fitc_RFP_ratio=fitc./RFP;

% Omit Inf, -Inf, NaN
TF = 1 - ismissing(original_fitc_RFP_ratio, id);
fitc_RFP_ratio=original_fitc_RFP_ratio(TF>0); 
% mean_norli(j)=mean(norfitc);
% std_norli(j)=std(norfitc);
% cv_norli(j)=std_norli(j)/mean_norli(j);

% Final data for each cell
gfitc_RFP_ratio(j,:) = {j, fitc_RFP_ratio};

% Final data for each sample
gmean_norfitc = mean(fitc_RFP_ratio);
gstd_norfitc = std(fitc_RFP_ratio);
gcv_norfitc = gstd_norfitc/gmean_norfitc;
gvar_norfitc = var(fitc_RFP_ratio);

mean_FITC_Ratio(j) = gmean_norfitc;

log_fitc_ratio=log10(data(:,3));
log_RFP_ratio=log10(data(:,4));

end

res = [mean_FITC_Ratio(1:12);mean_FITC_Ratio(13:24);mean_FITC_Ratio(25:36);mean_FITC_Ratio(37:48);mean_FITC_Ratio(49:60);]; %change data structure to mimic 96 well plate
cmv1 = [mean_FITC_Ratio(1:3);mean_FITC_Ratio(4:6);mean_FITC_Ratio(7:9);mean_FITC_Ratio(10:12)];
cmv3g = [mean_FITC_Ratio(13:15);mean_FITC_Ratio(16:18);mean_FITC_Ratio(19:21);mean_FITC_Ratio(22:24)];