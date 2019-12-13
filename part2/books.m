function bookindex=books(test_image_names, training_images_names)
    load calib_asus.mat;
    getFeaturesOfTrainingBooks; % Retorna F_train e D_train
    RemoveBackgroundOfTestImages; % Retorn F_test e D_test
    
    %% Find Books
    bookMATCHES = zeros(length(test_image_names),length(training_images_names));
    for i=1:length(test_image_names)
            for j=1:length(training_images_names)
                matches = vl_ubcmatch(D_train{j}, D_test{i}, 1.5);
                bookMATCHES(i,j)=length(matches);
                SimilarPoints1 = round(F_train{j}(1:2, matches(1, :)));
                SimilarPoints2 = round(F_test{i}(1:2, matches(2, :)));
            end
    end
    [MaxMatches bookindex] = max(bookMATCHES,[],2);
    for i=1:length(MaxMatches)
       if(MaxMatches(i)==0) 
          bookindex(i) = 0; 
       end
    end
end

