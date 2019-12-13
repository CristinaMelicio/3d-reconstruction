function PCloud = Im2PCloud(I1pointCloud, R, T, rgb_im, RGB_K, Rdtrgb, Tdrgb, GridStep, I2_AllPointsXYZ)
    % IMAGEM 2 - TRANSFORMAÇÃO R E T
    AllPoints2to1Rot = R * I2_AllPointsXYZ';
    AllPointsWorld2to1 = AllPoints2to1Rot' + repmat(T', length(AllPoints2to1Rot), 1);

    % IMAGEM 2 - ALINHAMENTO
    I2RGB = imread(rgb_im);
    I2RGBD = get_rgbd(I2_AllPointsXYZ, I2RGB, Rdtrgb, Tdrgb, RGB_K);

    % IMAGEM 2 - COR
    cl2 = reshape(I2RGBD, size(I2RGBD, 1) * size(I2RGBD, 2), 3);

    % IMAGEM 2 - POINT CLOUD
    I2pointCloud = pointCloud(AllPointsWorld2to1, 'Color', cl2);
    I2pointCloud = pcdownsample(I2pointCloud, 'gridAverage', GridStep);
    I2pointCloud = pcdenoise(I2pointCloud);
    % MERGE DAS DUAS
    PCloud = pcmerge(I2pointCloud, I1pointCloud, GridStep);
end

