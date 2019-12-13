for i = 1:length(training_images_names),
    %% Initialization
    load(training_images_names(i).depth);
    depth_array;  
    xyz=get_xyz_asus(depth_array(:),[480 640],(1:480*640), Depth_cam.K,1,0);
    errorthresh=0.01; niter=100;
    aux=fix(rand(3*niter,1)*length(xyz))+1;
    planos=[]; numinliers=[];
    %% Find planes in Training Images
    for j = 1:niter-3,
        pts=xyz(aux(3*j:3*j+2),:);
        %pseudoinversa
        A=[pts(:,1:2) ones(3,1)];
        plano=inv(A'*A)*A'*pts(:,3);
        planos=[planos plano];
        erro=abs(xyz(:,3)-[xyz(:,1:2) ones(length(xyz),1)]*plano);
        inds=find(erro<errorthresh);
        numinliers=[numinliers length(find(erro<errorthresh))];
    end
    
    [mm,ind]=max(numinliers);
    plano=planos(:,ind);
    erro=abs(xyz(:,3)-[xyz(:,1:2) ones(length(xyz),1)]*plano);
    inds=find(erro<errorthresh); % Indices que corresponderão ao background
    A=[xyz(inds,1:1) ones(length(inds),1)];
    planofinal= inv(A'*A)*A'*xyz(inds,3);
    pc2=pointCloud(xyz(inds,:),'Color',uint8(ones(length(inds),1)*[255 0 0]));
%     showPointCloud(pc2); 
    
    %% Using SIFT to get features of the training images
    im = imread(training_images_names(i).rgb);
    im = rgb2gray(im); im = im(:);
    im(inds, :) = 0;
    im(find(depth_array(:) == 0), :) = 0;
    im = reshape(im, [480 640]);
%     imagesc(im);
%     colormap(gray);
    [F1, D1] = vl_sift(single(im));
    F_train{i} = F1;
    D_train{i} = D1;
%     scatter(F1(1,:), F1(2,:));
end