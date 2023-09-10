function gen_result_file(dir, file_name, proj_vec, result, toggle_print)
% Generally output result
%
% Input Argument
% dir:          output directory
% file_name:    file name
% proj_vec:     projection vector
% toggle_print: if true, print result

    if toggle_print
        outp_file = fopen([dir, 'result.out'], 'wt');
        j = 1;
        % Title
        for i = 1:numel(proj_vec) + 4
            if i == 1
                fprintf(outp_file, '%15s\t', 'Name');
            elseif i == 2
                fprintf(outp_file, '%15s\t%15s\t', 'Volume', 'Surf Area');
            elseif i == 3
                fprintf(outp_file, '%15s\t%15s\t%15s\t', 'minBB Len', 'minBB Wid', 'minBB Thick');
            elseif i == 4
                fprintf(outp_file, '%15s\t%15s\t%15s\t', 'maxBB Len', 'maxBB Wid', 'maxBB Thick');
            elseif i >= 5
                fprintf(outp_file, '%15s\t%15s\t%15s\t%15s\t', ['Vec ', num2str(j), ' Area'], ['Vec ', num2str(j), ' Perim'], ['Vec ', num2str(j), ' Len'], ['Vec ', num2str(j), ' Wid']);
                j = j + 1;
            end
        end
        fprintf(outp_file, '\n');
        
        % Data
        for i = 1:length(file_name)
            fprintf(outp_file, '%15s\t', result{i, 1});
            for j = 2:4*numel(proj_vec) + 9 - 1
                fprintf(outp_file, '%15.7f\t', result{i, j});
            end
            fprintf(outp_file, '%15.7f\n', result{i, 4 * numel(proj_vec) + 9});
        end
        fclose(outp_file);
    end
end