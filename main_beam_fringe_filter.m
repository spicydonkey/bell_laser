% Beam profile analysis - cancelling camera interference fringe
%
% DKS
% 2018-05-26


%% config
% path to raw data
% dir_data='C:\Users\David\Documents\bell\laser\ram3_profile_fringe_postfilter\raw';
dir_data='C:\Users\HE BEC\Documents\lab\bell_momentumspin\laser\ram3_profile_fringe_postfilter\raw';

% camera
pixsize=20e-6;      % camera pixel pitch [m]


%% load data
d_dir=dir(dir_data);
d_names={d_dir.name}';
b_files=cellfun(@(s) is_file(fullfile(dir_data,s)),d_names);

filenames=d_names(b_files);

% TESTING
% filenames=filenames(randperm(numel(filenames)));
% filenames=filenames(1:1:end);
% TESTING END

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


%% estimate beam centers
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


%% overlay - beam centered
I_overlay=padarray(I_collated,img_size,NaN,'post');

for ii=1:n_img
    I_overlay(:,:,ii)=circshift(I_overlay(:,:,ii),img_size-idx_cent(ii,:));
end

I_ol_avg=mean(I_overlay,3,'omitnan');


%% process
% normalised beam profile image
I0=I_ol_avg/max(I_ol_avg(:));   



%% vis
imgol_size=size(I0);

xol=cell(1,2);
for ii=1:2
    xol{ii}=pixsize*(1:imgol_size(ii));
end
[Xol{1},Xol{2}]=ndgrid(xol{:});

figure('Name','normalised_beam_profile');
surf(1e3*Xol{1},1e3*Xol{2},I0,'EdgeColor','none','Facecolor','interp');
colormap('magma');
cbar=colorbar;
cbar.Label.String='Intensity (arb. unit)';
axis equal;
view(2);
xlabel('$x$ [mm]');
ylabel('$y$ [mm]');
