% Long-term monitoring of optical power in Raman laser system
% DKS
% 2018-05-24



%%% config
% path to raw csv from DMM
data_file='C:\Users\David\Documents\bell\laser\intensity_stab\exp1_20180523\raw\imes0001.csv';



%% main
dd=read_DMM_log(data_file);


%%% get data
t=dd(:,1);      % time (s)
V=dd(:,2);      % photodetector output voltage (V)
v=V/mean(V);   % normalised by the mean value

t_dur=seconds(t);

%%% statistics
v_std=std(v);       % relative uncertainty of intensity

% moving stat
k_mov=500;       % local no. points to eval stat

v_mov=cat(2,movmean(v,k_mov),movstd(v,k_mov));


%% visualise
%%% raw
figure('Name','Vt');
plot(hours(t_dur),v,'DisplayName','data');

xlabel('t [hour]');
ylabel('Beam Intensity (arb. unit)');


%%% moving average
figure('Name','intensity_mov');
shadedErrorBar(hours(t_dur),v_mov(:,1),v_mov(:,2));

xlabel('$t$ [hour]');
ylabel('Beam Intensity (arb. unit)');

