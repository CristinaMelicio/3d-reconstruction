function [pcloud, transforms] = reconstruction(image_names, depth_cam, rgb_cam, Rdtrgb,Tdtrgb)
    %% InitPointCloud STATE
    %REFERENCE FRAME -> depth camera coordinate system of the first image
    
    GridStep = 1e-3;
    [pcloud, AllPointsWorld1] = InitPointCloud(image_names(1).depth, depth_cam, image_names(1).rgb, rgb_cam, Rdtrgb, Tdtrgb, GridStep);
    %INICIALIZA A ROTAÇÃO E A TRANSLAÇÃO DE 1-1
    transforms(1).R = eye(3); transforms(1).T = [0 0 0]';
    %% AddToPointCloud MACROSTATE

    RANSAC_params.K = 80; % Relative Percentage of Inliers
    RANSAC_params.Th = 0.05; % Threshold
    RANSAC_params.Iter = 1e3;  % NMAX de Iterações
    RANSAC_params.N = 4; % Number of points to estimate Rotation and Translation

    for i = 1:length(image_names) - 1 
        [SimilarPixels1, SimilarPixels2] = Compare2Images(image_names(i).rgb, image_names(i+1).rgb);
        [Similar3DPts1, Similar3DPts2, AllPointsWorld2] = get3DInfoFromIm1and2(image_names(i).depth, image_names(i+1).depth, SimilarPixels1, SimilarPixels2, AllPointsWorld1, depth_cam);

        RANSAC_params.M = length(Similar3DPts1); % Data set

        [R21, T21, ~, ~] = RANSAC_to_Trans(Similar3DPts1, Similar3DPts2, RANSAC_params);

        transforms(i+1).R = transforms(i).R * R21;
        transforms(i+1).T = transforms(i).R * T21 + transforms(i).T;

        pcloud = Im2PCloud(pcloud, transforms(i+1).R, transforms(i+1).T, image_names(i+1).rgb, rgb_cam, Rdtrgb, Tdtrgb, GridStep, AllPointsWorld2);
        AllPointsWorld1 = AllPointsWorld2; 
    end
    pcloud = [pcloud.Location double(pcloud.Color)];
end
