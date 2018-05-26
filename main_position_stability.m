% Beam position stability
%
% DKS
% 2018-05-26


%% config
% path to raw data
dir_data='C:\Users\David\Documents\bell\laser\ram3_beam_stability\1\raw';

% camera
pixsize=20e-6;      % camera pixel pitch [m]

% data acquisition
dt=10;      % delay between img capture [s]


%% load data
d_dir=dir(dir_data);
d_names={d_dir.name}';
b_files=cellfun(@(s) isfile(fullfile(dir_data,s)),d_names);

filenames=d_names(b_files);

%%% sort images in order of capture sequence
% get file ID (num in seq)
f_id=cellfun(@(s) sscanf(s,'raman3_%d.png'),filenames);
% sort
[~,idx_srt]=sort(f_id);     % sorting index
filenames=filenames(idx_srt);

n_img=size(filenames,1);

Ic=cell(n_img,1);
for ii=1:n_img
    [tI,tX,tY,terr]=imread_bobcat(fullfile(dir_data,filenames{ii}));
    Ic{ii}=tI;
end
I_collated=cat(3,Ic{:});        % 3D array or images
X{1}=tX;
X{2}=tY;

img_size=size(X{1});

% get pixel image locations in 1D
x=cellfun(@(v) unique(v),X,'UniformOutput',false);

clearvars Ic;


%% estimate beam centers
% predicted center location + error

% weighted mean (centroid)
%   centroid is bound by input range
r0=NaN(n_img,2);
for ii=1:2
    r0(:,ii)=squeeze(sum(sum(I_collated.*X{ii},1),2)./sum(sum(I_collated,1),2));
end

% center location to index
idx_cent=NaN(n_img,2);
for ii=1:2
    [~,idx_cent(:,ii)]=min(abs(r0(:,ii)-x{ii}'),[],2);
end

clearvars I_collated;

%% process time-series
t=dt*(1:n_img)';             % time [s]
dr0=vnorm(r0-r0(1,:));      % beam displacement from initial position [m]


%%% simple statistics
% moving stat
k_mov=50;       % local no. points to eval stat

d_mov=cat(2,movmean(dr0,k_mov),movstd(dr0,k_mov));


%%% duration
t_dur=seconds(t);


%% vis
%%% raw data
figure('Name','beam_position_stabilty_raw');
plot(t,1e6*dr0);

xlabel('$t$ [s]');
ylabel('Beam displacement [$\mu$m]');


%%% moving average
figure('Name','beam_position_stability_mov');
shadedErrorBar(hours(t_dur),1e6*d_mov(:,1),1e6*d_mov(:,2));

xlabel('$t$ [hour]');
ylabel('Beam displacement [$\mu$m]');
