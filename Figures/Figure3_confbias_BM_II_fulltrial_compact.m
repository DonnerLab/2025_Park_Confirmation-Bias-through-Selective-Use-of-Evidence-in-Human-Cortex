% relevant data: gFTII_all_%s_parcels_%s_nosh.mat, gFTII_all_%s_parcels_%s_sh.mat

addpath('plot_maps')
addpath('BrewerMap')

conditions = {'attn', 'choice'};
condt = {'Cue','Choice'};
cic = {'con','incon'};

load('subjects.mat')

%% parameters
sf = 200;
etimep = -0.5:1/sf:4.5; % full length of ERF

d1s = 0.1;  
d2s = 0.5; 

d0s = {0.05, 0.20, 0.35, 0.50, 0.65, 0.80, 2.70, 2.85, 3.00, 3.15, 3.30, 3.45};
d0 = cellfun(@(x) find(etimep>x-0.5/sf & etimep<x+0.5/sf), d0s, 'UniformOutput', false); 
d0 = cell2mat(d0);
% get samples of onset times
bs10 = [d0(1); (round(sf*0.1)+1)*ones(5, 1); 1];
d11 = bs10 + d1s*sf;
d12 = bs10 + d2s*sf;
bs20 = (round(sf*0.1)+1)*ones(6, 1);
d21 = bs20 + d1s*sf;
d22 = bs20 + d2s*sf;

d1 = [d11 ; d21];
d2 = [d12 ; d22];
bs0 = [bs10 ; bs20];
bs0 = bs0-1;
bs0(7) = 1;

vws = [-50 7; 40 2];

gmapp = brewermap(90, '*PuRd'); gmapp = flip(gmapp); 
gmapn = brewermap(90, '*PuBuGn'); gmap = cat(1, gmapn, gmapp);
gmap=[0.5.*[1 1 1]; gmap; 0.4.*[1 1 1]]; 
pmap = brewermap(180, '*PuBu'); pmap = flip(pmap);
pmap=[0.5.*[1 1 1]; pmap; 0.4.*[1 1 1]]; 
tmap = brewermap(180, '*RdYlBu'); tmap=[0.5.*[1 1 1]; tmap; 0.4.*[1 1 1]];
ptmap = brewermap(180, '*YlGnBu'); ptmap = flip(ptmap); ptmap=[0.5.*[1 1 1]; ptmap; 0.4.*[1 1 1]];

hw = 5;
vw = hw*3/4;

target_type = 'sp';


%% ALL TRIALS int1, int2 6 DOTS AVERAGED: PLOT raw
clim = 10^-3.*[0 1.3];
dots = [1:6 8:13];
for c = 1:2
    load(sprintf('gFTII_all_%s_parcels_%s_nosh.mat', conditions{c}, target_type), 'gFTII')
    gFTII(181, :) = [];
    file_name = sprintf('gFTII_all_%s_parcels_%s_sh.mat', conditions{c}, target_type);
    sh = load(file_name);
    sh.gFTII(181, :) = [];
    datao = nan(180, 30, length(dots));
    for ii=1:size(gFTII,1)
        for d = 1:length(dots)
            % shuffle correction
            gFTII{ii,1}{dots(d)} = gFTII{ii,1}{dots(d)}-sh.gFTII{ii,1}{dots(d)};
            % baseline correction with trial-baseline
            gFTII{ii,1}{dots(d)} = gFTII{ii,1}{dots(d)}-repmat(nanmean(gFTII{ii,1}{dots(1)}(1:bs0(dots(1)), :), 1), size(gFTII{ii,1}{dots(d)}, 1), 1);
            datao(ii, :, d) = nanmean(gFTII{ii,1}{dots(d)}(d1(dots(d)):d2(dots(d)), :), 1);
        end
    end
    for int = 2%1:2
        data = nanmean(nanmean(datao(:, :, 1+6*(int-1):6*int), 3), 2);        
        a1 = [];
        % plot raw II data
        vis = figure('unit', 'centimeters', 'position', [2 2 hw vw]);
        a1(c,1) = axes;
        cfg = [];
        cfg.mom_dir = mdir;
        cfg.ah = a1(c,1);
        cfg.hemi = 'L';
        cfg.clim = clim;
        cfg.view = vws(1, :);
        cfg.cmap = pmap;
        cfg.colorbar = 'on';
        cfg.cbtext = 'II (bit)';
        cfg.amb = 0.7; % strength of ambient light D: 0.3, [0 1]
        cfg.diff = 0.5; % strength of diffuse light D: 0.6, [0 1]
        cfg.spec = 0.2; % strength or mirror like reflection D: 0.9, [0 1]
        vwt = 'lateral';
        hm = plot_bm(cfg, data);
        camlight(10, 10)
        hm.Ruler.Exponent = -3;
        hm.FontSize = 10;
        hm.Position = [hm.Position(1)+0.04 0.1+hm.Position(2) hm.Position(3) 0.5*hm.Position(4)];
        hm.Ticks = 10^-3.*[0 1.3];
        ax = gca;
        ax.Position = [ax.Position(1)-0.17 ax.Position(2) ax.Position(3) ax.Position(4)];
        sname = sprintf('brainmap_%s_IIsre_int%dmu_%s', conditions{c}, int, vwt)
%         print(vis, sname, '-dtiff', '-r300')
       
        % plot raw II data
        vis = figure('unit', 'centimeters', 'position', [3 3 hw vw]);
        a1(c,2) = axes; 
        cfg = [];
        cfg.mom_dir = mdir;
        cfg.ah = a1(c,2);
        cfg.hemi = 'L';
        cfg.clim = clim;
        cfg.view = vws(2, :);
        cfg.cmap = pmap;
        cfg.colorbar = 'on';
        cfg.cbtext = 'II (bit)';
        cfg.amb = 0.7; % strength of ambient light D: 0.3, [0 1]
        cfg.diff = 0.5; % strength of diffuse light D: 0.6, [0 1]
        cfg.spec = 0.2; % strength or mirror like reflection D: 0.9, [0 1]
        vwt = 'medial';
        hm = plot_bm(cfg, data);
        camlight(2, 10)
        hm.Ruler.Exponent = -3;
        hm.FontSize = 10;
        hm.Position = [hm.Position(1)+0.04 0.1+hm.Position(2) hm.Position(3) 0.5*hm.Position(4)];
        hm.Ticks = 10^-3.*[0 1.3];
        ax = gca;
        ax.Position = [ax.Position(1)-0.17 ax.Position(2) ax.Position(3) ax.Position(4)];
        sname = sprintf('brainmap_%s_IIsre_int%dmu_%s', conditions{c}, int, vwt)
%         print(vis, sname, '-dtiff', '-r300')
    end
end

