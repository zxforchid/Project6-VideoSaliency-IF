%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% demo code
%% 2019.01.14 13:42PM
%% copyright by xiaofei zhou.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc
%% 1 initial --------------------------------------------------------
use_gpu=1;
% Set caffe mode
if exist('use_gpu', 'var') && use_gpu
  caffe.set_mode_gpu();
  gpu_id = 0;  % we will use the first gpu in this demo
  caffe.set_device(gpu_id);
else
  caffe.set_mode_cpu();
end

net_model = './DOME/deploy.prototxt';
net_weights = './DOME/iter_12000.caffemodel';

phase = 'test'; 
net = caffe.Net(net_model, net_weights, phase);


%% 2 begin ---------------------------------------------------------
rgbPath = ['./DOME/testData/IMG/'];
motionPath = ['./DOME/testData/opp/'];

rgb_root_videoDataSet=[rgbPath];
videoNames = dir(rgb_root_videoDataSet);
videoNames = videoNames(3:end);

 for vn=1:length(videoNames)
       fprintf( ['VideoName: ',videoNames(vn).name,'\n']);

       % path of video data
       rgb_video_data=[rgb_root_videoDataSet,videoNames(vn).name,'/'];
       motion_video__data = [motionPath,videoNames(vn).name,'/'];

       % result path
         saliencyMap=['./DOME/Results/',videoNames(vn).name,'/'];
        if( ~exist( saliencyMap, 'dir' ) )
            mkdir( saliencyMap );
        end
        
        % obtain each frame
        rgbfiles = dir([rgb_video_data '*.jpg']);
        if length(rgbfiles)==0
            rgbfiles = dir([rgb_video_data '*.png']);
        end
        num = length(rgbfiles);

        % start
        for f=1:num%length(frames)
            name = rgbfiles(f).name;%(1:end-4);
            % RGB --------------------------------------------------------
            rgb_im = imread([rgb_video_data name]);
            if size(rgb_im,3)==1
               rgb_im = cat(3,rgb_im,rgb_im,rgb_im);
            end
            data_t = prepare_image(rgb_im);
            net.blobs('data_t').reshape([size(data_t) 1]);
    
             % motion images ---------------------------------------------
            load([motion_video__data name(1:end-4) '.mat']);
            motion_im = flowToColor(MVF_Foward_f_fp); clear MVF_Foward_f_fp
            if size(motion_im,3)==1
               motion_im = cat(3,motion_im,motion_im,motion_im);
            end
            motion_im = uint8(motion_im);
            data_t1 = prepare_image(motion_im);
            clear motion_im
            net.blobs('data_t1').reshape([size(data_t1) 1]);
            
            % test -------------------------------------------------------
            res = net.forward({data_t,data_t1});
            be_map = permute(res{1}(:,:,1), [2 1 3]);
            fe_map = permute(res{1}(:,:,2), [2 1 3]);
            diff_map(:,:,1) = fe_map - be_map; 
            mean_map = mean(diff_map,3);
            tmpsalmap = max(0,mean_map);
            lossSal = normalizeSal(tmpsalmap);   
            
            % resize ------------------------------------------------------
            salmap = lossSal;
            salmap = normalizeSal(salmap);
            clear lossSal contSal
            
            salmap  = imresize(salmap,[size(rgb_im,1) size(rgb_im,2)], 'bilinear');           
            salmap2= guidedfilter(salmap,salmap,6,0.1);
            salmap2 = normalizeSal(salmap2);
            IMSAL2 = uint8(255*salmap2);
            imwrite(IMSAL2,[saliencyMap,name(1:end-4),'.png']) 
            
            clear im prior_map map salmap rgb_im salmap2 IMSAL2
        end
        
        clear rgbfiles
 end
    
%% ------------------------------
msgbox(['well done!!!'])


