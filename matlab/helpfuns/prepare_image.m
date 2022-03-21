 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  ------------------------------------------------------------------------
function images = prepare_image(im)
%% ------------------------------------------------------------------------
% IMAGE_DIM = 256;
IMAGE_DIM = 288; % Use this resolution for better results
% resize to fixed input size
im = single(im);
im = imresize(im, [IMAGE_DIM IMAGE_DIM], 'bilinear');
% permute from RGB to BGR (IMAGE_MEAN is already BGR)
im = im(:,:,[3 2 1]);
% subtract mean_data (already in W x H x C, BGR)
im(:,:,1) = im(:,:,1) -104 ;  
im(:,:,2) = im(:,:,2) -117 ;
im(:,:,3) = im(:,:,3) -123 ;
images = permute(im,[2 1 3]);
% ------------------------------------------------------------------------
end