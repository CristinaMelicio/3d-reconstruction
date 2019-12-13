function [SimilarPoints1, SimilarPoints2 ] = Compare2Images(I1, I2)
    % [SimilarPoints1, SimilarPoints2] = Compare2Images(I1, I2)
    % Inputs: Path to RGB Image1 and to RGB Image2. 
    % Outputs: Indexes of Pixels of the features with the best similarity between I1 and I2.  

    I1 = imread(I1);
    I1 = single(rgb2gray(I1));

    I2 = imread(I2);
    I2 = single(rgb2gray(I2));

    [F1, D1] = vl_sift(I1);   % detect and describe local features in image1
    [F2, D2] = vl_sift(I2);   % detect and describe local features in image2

    matches = vl_ubcmatch(D1, D2, 2);   % Match Similar Descriptors
    % São armazenados os descritores de I1 e I2 com maior semelhança.

    SimilarPoints1 = round(F1(1:2, matches(1, :))); % F1(1:2) -> x and y Respectively 
    SimilarPoints2 = round(F2(1:2, matches(2, :))); % Round is used to approximate to the nearest pixel
end

