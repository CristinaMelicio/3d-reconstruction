%% Remove Backgroung in Testing Images
load(test_image_names(1).depth);
bgim = rgb2gray(imread(test_image_names(i).rgb));
bgimd = depth_array(:);
bgimd = double(reshape(bgimd, [480 640]));

for i=1:length(test_image_names),
    im=rgb2gray(imread(test_image_names(i).rgb));
    foreg=abs(double(im)-double(bgim))>40;
    load(test_image_names(i).depth);
    foregd=abs(double(depth_array)-double(bgimd))>150;
    depthIMAGE =double(max(depth_array(:)))*imopen((foregd),strel('disk',10));
    inds = find(depthIMAGE == 0);
    im = im(:);
    im(inds, :) = 0;
    im = reshape(im, [480 640]);
    [F1, D1] = vl_sift(single(im));
    F_test{i} = F1;
    D_test{i} = D1;
end