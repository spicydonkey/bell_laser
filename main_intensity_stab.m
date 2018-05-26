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


%%% statistics
v_std=std(v)       % relative uncertainty of intensity



%% visualise
figure('Name','Vt');
plot(t,v,'.','DisplayName','data');

xlabel('t [s]');
ylabel('Beam Intensity (arb. unit)');

vf=smooth(v,100);

hold on;
plot(t,vf,'-','DisplayName','smoothed','LineWidth',2);

legend('show');


