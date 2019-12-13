function [R21, T21, Iterations, MaxRatioInliers] = RANSAC_to_Trans(Similar3DPts1, Similar3DPts2, params)

M = params.M;
K = params.K/100; % Relative Percentage of Inliers
Threshold = params.Th; % Threshold
L = params.Iter; % NMAX de Iterações
N = params.N; % % Number of points to estimate Rotation and Translation 

Iterations = 0;
MaxRatioInliers = 0;

    while 1
        if Iterations > L
            break;
        end
        Indexes = round((M-1) * rand(1, N) + 1);
        [R21, T21] = getRotTrans(Similar3DPts1(Indexes, :), Similar3DPts2(Indexes, :));
        Similar3DPts2aux = R21 *  Similar3DPts2';
        Similar3DPts2aux = Similar3DPts2aux' + repmat(T21', length(Similar3DPts2aux), 1);
        Error = Similar3DPts1 - Similar3DPts2aux;
        Error = sqrt(sum(Error.^2, 2));
        Test = Error < Threshold;
        N_Inliers = sum(Test);
	    if N_Inliers > MaxRatioInliers
            MaxRatioInliers = N_Inliers;
            KeepIndexes = find(Test);
        end
	    Iterations = Iterations + 1;
        if(N_Inliers > K * M)
            break;
        end
    end
    [R21, T21] = getRotTrans(Similar3DPts1(KeepIndexes, :), Similar3DPts2(KeepIndexes, :));
    MaxRatioInliers = floor(MaxRatioInliers/M * 100);
    
    % Calculo do ERRO
            T = repmat(T21',length(Similar3DPts1(KeepIndexes, :)),1);
            E = Similar3DPts1(KeepIndexes, :)'-(R21*Similar3DPts2(KeepIndexes, :)' + T');
            Error = sqrt(sum(E'.^2,2));
            Error = sum(Error)/length(Similar3DPts1(KeepIndexes, :));
    
end

