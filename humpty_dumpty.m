% path to file: /Users/sophorskhut/Google Drive/eggshell/eggdata/neweggboundaries/
function result = humpty_dumpty(path)
   
    % load all files from path
    function [store, smooth_cell] = load(path)
        % adding '*.txt' to load all file in path
        path_all_files = strcat(path, '*.txt');
        files = dir(path_all_files);
        num_files = length(files);
        
        store = {};
        smooth_cell = {};
        
        for i=1:num_files
            each_file = files(i).name;
            each_file
            new_path = strcat(path, each_file);
            
            % read each file
            piece = csvread(new_path);
            store{i} = piece;
            smooth_cell{i} = smoothing(piece);
        end         
    end

    % smoothing function apply to each piece
    function ppvals = smoothing(piece)
        
        n = size(piece,1);
        bptssam = piece(1:n,:);

        t = 1:n;

        % One can supply a smoothing parameter s between 0 and 1
        s = .06;
        pp = csaps(t,bptssam',s); 
        ppvals =  ppval(pp,t);
        ppvals = ppvals';
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

    
    % Given bivertex arcs of two curves, the function outputs start row,
    % col and end row, col
    function trace = tracing(data1, data2)
        
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
    function d = findMatch(path)
      
        [data, smooth_data] = load(path);
        num_pieces = size(smooth_data, 2);        
        
        %plot3(data{3}(:,1), data{3}(:,2), data{3}(:,3), '.r');
        %hold on;
        %plot3(smooth_data{3}(:,1), smooth_data{3}(:,2), smooth_data{3}(:,3), '.b')
        
        
        for i=1:(num_pieces - 1)
            data1 = data{i};
            for j=(i+1):num_pieces
                data2 = data{j};                
                trace = tracing(data1, data2);
                fprintf('Matching for pieces: %d and %d\n', i, j);
                printData(trace);
                disp('================================');
                
%                 map = trace{1};
%                 start_row = map('start_row');
%                 start_col = map('start_col');
%                 end_row = map('end_row');
%                 end_col = map('end_col');
%                 
%                 bivertex_arcs1 = trace{2};
%                 bivertex_arcs2 = trace{3};
%                 
%                 start_f = convertIndexS(bivertex_arcs1, start_row);
%                 end_f = convertIndexE(bivertex_arcs1, end_row);
%                 
%                 plot3(data1(start_f:end_f, 1), data1(start_f:end_f, 2), data1(start_f:end_f, 3), 'r');
%                 hold on;
%                 plot3(data2(trace{4}:trace{5}, 1), data2(trace{4}:trace{5}, 2), data2(trace{4}:trace{5}, 3), 'b');                
               
                % trace without reversing
                trace2 = tracing(data1,data2(end:-1:1,:));
                fprintf('Matching for pieces: %d and %d\n, reversed', i, j);
                printData(trace2);
                disp('================================');
            end
        end

        d=1;
        %d = table1;
        
    end

    result = findMatch(path);

end