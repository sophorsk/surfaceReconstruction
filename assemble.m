% Read the csv file - four files
% compute the bivertex arcs

function result = assemble(filename1, filename2, filename3, filename4)

    % load the csv data into a cell array structure
    function load = loadData(filename1, filename2, filename3, filename4)
        % load the csv data
        data1 = csvread(filename1);
        data2 = csvread(filename2);
        data3 = csvread(filename3);
        data4 = csvread(filename4);
        
        load = {};
        load{1} = data1;
        load{2} = data2;
        load{3} = data3;
        load{4} = data4;
    end
    
    % construct the matrix score between two bivertex arcs
    function table = bivertexTable(bivertex_arcs1, bivertex_arcs2)
        
        table = [];
        num_arcs1 = size(bivertex_arcs1, 1);
        num_arcs2 = size(bivertex_arcs2, 1);
        
        for i=1:num_arcs1
            for j=1:num_arcs2
                table(i, j) = similarityCoefficient(bivertex_arcs1{i}, bivertex_arcs2{j});
            end
        end
    end
   
    % Add rotation and translation to the data
    function rotate = rotateData(data)
        
        lt = size(data, 1);
        
        % thetax,thetay,thetaz are randomly chosen angles of rotation (between
        % 0 and 2*pi) around each axis.
        thetax = 2*pi*rand(1);
        thetay = 2*pi*rand(1);
        thetaz = 2*pi*rand(1);

        % here we construct the rotation matrix
        rotx = [1 0 0; 0 cos(thetax) -sin(thetax); 0 sin(thetax) cos(thetax)];
        roty = [cos(thetay) 0 sin(thetay); 0 1 0; -sin(thetay) 0 cos(thetay)];
        rotz = [cos(thetaz) -sin(thetaz) 0;sin(thetaz) cos(thetaz) 0; 0 0 1];
        
        % a random vector of translation, values chosen between -1 and 1
        translation = [2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt); 2*(rand(1)-.5)*ones(1,lt)];
        
        rotate = data*rotx*roty*rotz + transpose(translation);
        
    end


    % Given bivertex arcs of two curves, the function outputs start row,
    % col and end row, col
    function trace = tracing(data1, data2)
        
        % need to reverse the data clockwise vs anticlockwise
        data2 = data2(size(data2, 1): -1: 1, :);
        
        data1 = transpose(data1);
        data2 = transpose(data2);
        
        % create bivertex arcs for all data
        bivertex_arcs1 = allBivertices(data1);
        bivertex_arcs2 = allBivertices(data2);
        
        bivertex_arcs1
        bivertex_arcs2
        
        % build a similarity score matrix between two curves
        table = bivertexTable(bivertex_arcs1, bivertex_arcs2);
        
        max(table(:))
        
        % table1
        [r_max, c_max] = find(table == max(table(:)));
        
        % they shared the boundary
        first_row = r_max(1);
        first_col = c_max(1);
        
        % record indices here - Index of the curve not bivertex
        start_row = first_row;
        start_col = first_col;
        end_row = r_max(size(r_max, 1));
        end_col = c_max(size(r_max, 1));
        
        max_row = size(table, 1);
        max_col = size(table, 2);
        
        threshold = 0.9;
        
        % if they share boundary, we should get maximum value > 0.99
        if max(table(:)) > threshold
            
            % upward diagonal tracing
            % check if the entry > 0.99 or is 0 and start_row and
            % start_col > 0
            while ((table(start_row, start_col) > threshold || table(start_row, start_col) == 0) && (start_row > 0 && start_col > 0))
                start_row = start_row - 1;
                start_col = start_col - 1;
            end
            
            % downward diagonal tracing
            while ((table(end_row, end_col) > threshold || table(end_row, end_col) == 0) && (end_row < max_row && end_col < max_col))
                end_row = end_row + 1;
                end_col = end_col + 1;
            end
        end
        
        map = containers.Map();
        map('start_row') = start_row;
        map('start_col') = start_col;
        map('end_row') = end_row;
        map('end_col') = end_col;
                
        trace = {};
        trace{1} = map;
        trace{2} = bivertex_arcs1;
        trace{3} = bivertex_arcs2;
        
        trace{4} = length(data2)+1-convertIndexE(bivertex_arcs2, end_col);
        trace{5} = length(data2)+1-convertIndexS(bivertex_arcs2, start_col);
        
    end

    % print out the data
    function p = printData(traceCell)
        map = traceCell{1};
        start_row = map('start_row');
        start_col = map('start_col');
        end_row = map('end_row');
        end_col = map('end_col');
        
        fprintf('Start Row is: %d\n', start_row);
        fprintf('Start Col is: %d\n', start_col);
        fprintf('End Row is: %d\n', end_row);
        fprintf('End Col is: %d\n', end_col);
        
        bivertex_arcs1 = traceCell{2};
        bivertex_arcs2 = traceCell{3};
        
        fprintf('Starting Index of 1: %d\n', convertIndexS(bivertex_arcs1, start_row));
        fprintf('Ending Index of 1: %d\n', convertIndexE(bivertex_arcs1, end_row));
        
        fprintf('Starting Index of 2: %d\n', traceCell{4});
        fprintf('Ending Index of 2: %d\n', traceCell{5});
        
        % check if both curves contain the same bivertex arcs
        
%         while (start_row <= end_row)
%             bivertex_arcs1{start_row}
%             bivertex_arcs2{start_col}
%                        
%             start_row = start_row + 1;
%             start_col = start_col + 1;
%         end      
    end

    
    % This function converts the index of bivertex arcs to index of points
    function index = convertIndexE(bivertex_arcs, arc_index)
        index = 0;
        for i=1:arc_index
            element_size = size(bivertex_arcs{i}, 2);
            index = index + element_size;
        end
    end   

    function index = convertIndexS(bivertex_arcs, arc_index)
        index = 1;
        for i = 1:arc_index-1
            index = index + size(bivertex_arcs{i},2);
        end
    end

    % This function prints out the matching information among data
    function d = findMatch(filename1, filename2, filename3, filename4)
        
        load = loadData(filename1, filename2, filename3, filename4);
        for i=1:4
            load{i} = rotateData(load{i});
        end
        
        
%         new_data = load{1};
%         csvwrite('~/Google Drive/eggshell/code/puzzle6/piece1.dat', new_data);
%         new_data = load{2};
%         csvwrite('~/Google Drive/eggshell/code/puzzle6/piece2.dat', new_data);
%         new_data = load{3};
%         csvwrite('~/Google Drive/eggshell/code/puzzle6/piece3.dat', new_data);
%         new_data = load{4};
%         csvwrite('~/Google Drive/eggshell/code/puzzle6/piece4.dat', new_data);
%         
        num_pieces = size(load, 2);        

        for i=1:(num_pieces - 1)
            data1 = load{i};
            for j=(i+1):num_pieces
                data2 = load{j};                
                trace = tracing(data1, data2);
                fprintf('Matching for pieces: %d and %d\n', i, j);
                printData(trace);
                disp('================================');
            end
        end

        d=1;
        %d = table1;
        
    end

    result = findMatch(filename1, filename2, filename3, filename4);

end
