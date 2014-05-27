% This matlab program finds centroids and the rotation matrix 
% to rotate from one curve to another.

function map = compute_procrustes(curve1, curve2)

    % 1. compute the centroid
    dimension1 = size(curve1, 2);
    dimension2 = size(curve2, 2);
    
    first_centroid = [0; 0; 0];
    for i = 1:dimension1
       first_centroid = first_centroid + curve1(:, i);
    end
    
    second_centroid = [0; 0; 0];
    for j = 1:dimension2
       second_centroid = second_centroid + curve2(:, j); 
    end
    
    first_centroid = first_centroid/dimension1;
    second_centroid = second_centroid/dimension2;
    
    % translate the centroid to the origin
    for i = 1:dimension1
        curve1(:, i) = curve1(:, i) - first_centroid; 
    end
 
    for i = 1:dimension2
        curve2(:, i) = curve2(:, i) - second_centroid;
    end

    % 2. Find the rotation using SVD according to Procrustes algorithm
    C = curve1*transpose(curve2);
    [U, S, V] = svd(C);
    Q = U * transpose(V);
    rotation = Q;
    
    map = containers.Map();
    map('c1') = first_centroid;
    map('c2') = second_centroid;
    map('rot') = rotation;
    
end