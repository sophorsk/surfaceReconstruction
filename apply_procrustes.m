% This matlab program applies Procrustes algorithm to 
% find the centroid and rotation matrix. 

function result = apply_procrustes(filename1, filename2) 
    
    % load two curves
    function load = loadData(filename1, filename2)
        data1 = csvread(filename1);
        data2 = csvread(filename2);
        
        load = {};
        load{1} = transpose(data1);
        load{2} = transpose(data2); 
    end

    % find the rotation matrix
    function matrix = findMatrix(filename1, filename2) 
        load = loadData(filename1, filename2);
        data1 = load{1};
        data2 = load{2};
        matrix = compute_procrustes(data1, data2);
    end
    
    result = findMatrix(filename1, filename2);

end