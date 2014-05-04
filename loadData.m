    function result = loadData(data)
        
        data = rotateData(data);
        result = addNoise(data);
       %result = transpose(noise);
        
        function noise = addNoise(data)
        size_data = size(data, 1);
        noise = data;
            for i=1:size_data
                value = .0000055*rand(1);
                noise(i, :) = data(i, :) + value;
            end
        end
        
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
        tran = transpose([2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt)]);
        
        rotate = data*rotx*roty*rotz + tran;
        
        end
       
       
       
    end
  