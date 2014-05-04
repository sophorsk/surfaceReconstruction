function generateData = manipulator(filename1, filename2, filename3, filename4) 
    
    % load the csv data into a cell array structure
    function load = loadData(filename1, filename2, filename3, filename4)
       
        % load the csv data
        data1 = csvread(filename1);
        data2 = csvread(filename2);
        data3 = csvread(filename3);
        data4 = csvread(filename4);

        %data1 = transpose(data1);
        %data2 = transpose(data2);
        %data3 = transpose(data3);
        %data4 = transpose(data4);
                
        
        new_data = manipulate(data1);
        csvwrite('~/Google Drive/eggshell/code/puzzle4/piece1.dat', new_data);
        
        new_data = manipulate(data2);
        csvwrite('~/Google Drive/eggshell/code/puzzle4/piece2.dat', new_data);
        
        new_data = manipulate(data3);
        csvwrite('~/Google Drive/eggshell/code/puzzle4/piece3.dat', new_data);
        
        new_data = manipulate(data4);
        csvwrite('~/Google Drive/eggshell/code/puzzle4/piece4.dat', new_data);
        
        load=0;
    end

%     function rload = reverse(filename1, filename2, filename3, filename4)
%        
%         data = loadData(filename1, filename2, filename3, filename4);
%         
%         rload = {};
%         rload{1} = data{1}(size(data{1}, 1): -1: 1, :);
%         rload{2} = data{2}(size(data{2}, 1): -1: 1, :);
%         rload{3} = data{3}(size(data{3}, 1): -1: 1, :);
%         rload{4} = data{4}(size(data{4}, 1): -1: 1, :);
%     end

    function result = manipulate(data)
  %      data = rotateData(data);
        noise = addNoise(data);
  %      result = transpose(noise);
        result=noise;
    end

    function noise = addNoise(data)
%        size_data = size(data, 2);
        size_data = size(data, 1);
        noise = data;
        for i=1:size_data
            value = .0000055*rand(1);
            noise(i, :) = data(i, :) + value;
        end
    end    

    % can call both data and rdata so that they have the same rotation, but
    % seems not a good approach
     % Add rotation and translation to the data
    function rotate = rotateData(data)
        
        lt = size(data, 1);
        
        % thetax,thetay,thetaz are randomly chosen angles of rotation (between
        % 0 and 2*pi) around each axis.
          thetax = 2*pi*rand(1);
          thetay = 2*pi*rand(1);
          thetaz = 2*pi*rand(1);
%         
%         thetax = 2*pi*0;
%         thetay = 2*pi*0;
%         thetaz = 2*pi*0;

        % here we construct the rotation matrix
        rotx = [1 0 0; 0 cos(thetax) -sin(thetax); 0 sin(thetax) cos(thetax)];
        roty = [cos(thetay) 0 sin(thetay); 0 1 0; -sin(thetay) 0 cos(thetay)];
        rotz = [cos(thetaz) -sin(thetaz) 0;sin(thetaz) cos(thetaz) 0; 0 0 1];
        
        % a random vector of translation, values chosen between -1 and 1
        translation = transpose([2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt)]);
        
        rotate = data*rotx*roty*rotz + translation;
        
    end

    generateData = loadData(filename1, filename2, filename3, filename4);
end