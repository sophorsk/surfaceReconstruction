% Read the csv file - four files
% compute the bivertex arcs

function result = images(filename1, filename2, filename3, filename4)

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

    % remove all single points
%    function newBivertex = removeSingle(bivertex_arcs)
%        num_arcs = size(bivertex_arcs, 1);
%        for i=1:num_arcs
%            if size(bivertex_arcs{i}, 2) == 1
%                bivertex_arcs{i} = [];
%            end
%        end
        
%        emptyCells = cellfun('isempty', bivertex_arcs);
%        bivertex_arcs(all(emptyCells, 2), :) = [];
        
%        newBivertex = bivertex_arcs;
%    end


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
        
        % build a similarity score matrix between two curves
        table = bivertexTable(bivertex_arcs1, bivertex_arcs2);
        
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

        % if they share boundary, we should get maximum value > 0.99
        if max(table(:)) > 0.99
            threshold = 0.99;
            
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
        
        S1 = convertIndexS(bivertex_arcs1, start_row);
        E1 = convertIndexE(bivertex_arcs1, end_row);
        
        E2 = size(data2,2)+1-convertIndexS(bivertex_arcs2, start_col);
        S2 = size(data2,2)+1-convertIndexE(bivertex_arcs2, end_col);
        
        trace = {};
        trace{1} = map;
        trace{2} = [S1, E1, S2, E2];
        
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
        
        
        fprintf('Starting Index of 1: %d\n', traceCell{2}(1));
        fprintf('Ending Index of 1: %d\n', traceCell{2}(2));
        
        fprintf('Starting Index of 2: %d\n', traceCell{2}(3));
        fprintf('Ending Index of 2: %d\n', traceCell{2}(4));
        
        % check if both curves contain the same bivertex arcs
        
%         while (start_row <= end_row)
%             bivertex_arcs1{start_row}
%             bivertex_arcs2{start_col}
%                        
%             start_row = start_row + 1;
%             start_col = start_col + 1;
%         end      
    end

    
    % This function converts the STARTING index of bivertex arcs to the STARTING index of points
    function index = convertIndexS(bivertex_arcs, arc_index)
        index = 1;
        for i=1:arc_index-1
            index = index + size(bivertex_arcs{i}, 2);
        end
    end    

    % This function converts the ENDING index of bivertex arcs to the ENDING index of points
    function index = convertIndexE(bivertex_arcs, arc_index)
        index = 0;
        for i=1:arc_index
            index = index + size(bivertex_arcs{i}, 2);
        end
    end    


    % This function prints out the matching information among data
    function d = findMatch(filename1, filename2, filename3, filename4)
        
        load = loadData(filename1, filename2, filename3, filename4);
        num_pieces = size(load, 2);
        
        % Plot each piece
        figure;
        for i=1:4
            subplot(2,2,i)
            plot3(load{i}(:,1), load{i}(:,2), load{i}(:,3))
            rotate3d on;
            title(['Piece', num2str(i)])
        end
        
        % Plot all pieces together
        figure;
        rotate3d on;
        for i=1:4
            plot3(load{i}(:,1), load{i}(:,2), load{i}(:,3))
            hold on;
        end
        
        % Loop over each pair of pieces to find matches
        for i=1:(num_pieces - 1)
            data1 = load{i};
            for j=(i+1):num_pieces
                data2 = load{j};
                trace = tracing(data1, data2);
                
                % Mark the overlapped part in red
                range1 = trace{2}(1):trace{2}(2);
                plot3(data1(range1,1), data1(range1,2), data1(range1,3), 'r+')
                hold on;
                range2 = trace{2}(3):trace{2}(4);
                plot3(data2(range2,1), data2(range2,2), data2(range2,3), 'r+')
                hold on;
                
                % Print out key matching information
                fprintf('Matching for pieces: %d and %d\n', i, j);
                printData(trace);
                disp('================================');
            end
        end
        
        d=1;
    
    end

result = findMatch(filename1, filename2, filename3, filename4);

end


