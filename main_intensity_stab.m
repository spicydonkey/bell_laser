% Long-term monitoring of optical power in Raman laser system
% DKS
% 2018-05-24
%
%
% TODO
%


%% config
%%% directory to sequential csv data (with raw csv files from DMM)

% data_dir='C:\Users\HE BEC\Documents\lab\bell_momentumspin\laser\intensity_stab\exp1_20180523';
data_dir='C:\Users\HE BEC\Documents\lab\bell_momentumspin\laser\intensity_stab\exp2_20180524';


%% main
%%% LOAD: Read all sequential csv files from DMM - parsing the directory
% parse directory for DMM outputs
f_list=dir(data_dir);
f_name={f_list.name}';   % names of all outputs
% filter for files
b_file=cellfun(@(s) is_file(fullfile(data_dir,s)),f_name);    
f_name=f_name(b_file);

nfiles=numel(f_name);

D=cell(nfiles,1);
for ii=1:nfiles
    D{ii}=read_DMM_log(fullfile(data_dir,f_name{ii}));
end

% concatenate sequential files
dd=D{1};
for ii=2:nfiles
    t0_this=dd(end,1)+mean(diff(dd(:,1)));
    dd=vertcat(dd,D{ii}+[t0_this,0]);
end
%%% LOAD end


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

