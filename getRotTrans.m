function [R21, T21] = getRotTrans(SimilarPointsWorld1, SimilarPointsWorld2)

    % Get Centroid1
    N = length(SimilarPointsWorld1);
    Centroid1 = 1/N * [sum(SimilarPointsWorld1(:,1)); sum(SimilarPointsWorld1(:,2)); sum(SimilarPointsWorld1(:,3))];
    
    %                          Sum all Xi'                     Sum all Yi'                    Sum all Zi'        
    % Do Pi' - centroid1
    A =  SimilarPointsWorld1 - repmat(Centroid1', length(SimilarPointsWorld1), 1);  
    
    % Get Centroid2
%   N = length(SimilarPointsWorld2);
    Centroid2 = 1/N * [sum(SimilarPointsWorld2(:,1)); sum(SimilarPointsWorld2(:,2)); sum(SimilarPointsWorld2(:,3))]; % 
    %                          Sum all Xi                     Sum all Yi                    Sum all Zi                      
    % Do Pi - centroid2
    B =  SimilarPointsWorld2 - repmat(Centroid2', length(SimilarPointsWorld2), 1);

    % Get R and T
    [u Sigma v] = svd(B'*A);    

    R12 = u*v';
    R21 = R12';
    T21 = Centroid1 - R21 * Centroid2; 
end

