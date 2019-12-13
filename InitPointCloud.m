function [I1pointCloud, I1_AllPointsXYZ] = InitPointCloud(depth_im, depth_cam_K, rgb_im, rgb_cam_K, Rdtrgb, Tdrgb, GridStep)
    %IMAGEM 1 - XYZ
    I1_depth = load(depth_im);
    ZGoodIndex = find(I1_depth.depth_array);
    I1_AllPointsXYZ = get_xyz_asus(I1_depth.depth_array(:), size(I1_depth.depth_array), ZGoodIndex, depth_cam_K, 1, 0);

    % IMAGEM 1 - ALINHAMENTO
    I1RGB = imread(rgb_im);
    I1RGBD = get_rgbd(I1_AllPointsXYZ, I1RGB, Rdtrgb, Tdrgb, rgb_cam_K);

    %IMAGEM 1 - COR
    cl1 = reshape(I1RGBD, size(I1RGBD,1) * size(I1RGBD,2), 3);

    %IMAGE 1 - POINT CLOUD
    I1pointCloud = pointCloud(I1_AllPointsXYZ, 'Color', cl1);
    I1pointCloud = pcdownsample(I1pointCloud, 'gridAverage', GridStep); 
    I1pointCloud = pcdenoise(I1pointCloud); 
end

