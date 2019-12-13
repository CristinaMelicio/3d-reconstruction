function [SimilarPointsWorld1, SimilarPointsWorld2, AllPointsWorld2] = get3DInfoFromIm1and2(I1_depth, I2_depth, SimilarPixels1, SimilarPixels2, AllPointsWorld1, K)
    
    I1_depth = load(I1_depth);
    Index = sub2ind([size(I1_depth.depth_array, 1) size(I1_depth.depth_array, 2)], SimilarPixels1(2, :), SimilarPixels1(1, :));
    SimilarPointsWorld1 = AllPointsWorld1(Index, :);    % Get only the 3D points from the features
    
    I2_depth = load(I2_depth);
    ZGoodIndex = find(I2_depth.depth_array);
    AllPointsWorld2 = get_xyz_asus(I2_depth.depth_array(:), size(I2_depth.depth_array), ZGoodIndex, K, 1, 0); % Get all 3DPoints from IM1
    Index = sub2ind([size(I2_depth.depth_array, 1) size(I2_depth.depth_array, 2)], SimilarPixels2(2, :), SimilarPixels2(1, :));
    SimilarPointsWorld2 = AllPointsWorld2(Index, :);    % Get only the 3D points from the features
end

