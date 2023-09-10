function [file_dir, file_name] = search_inp_file(file_dir, file_suffix)
% Get the name of data cloud files
% 
% Input Argument
% file_dir:    directory of data cloud files
% file_suffix: suffix of data cloud files
% 
% Output Argument
% file_dir:    directory of data cloud files, end with '\'
% file_name:   name of data cloud files without suffix

    %[file_dir, ~, ~] = fileparts(mfilename('file_dir'));
    file_dir = [file_dir,'\'];
    file_name_suffix = dir([file_dir, file_suffix]);

    file_num = length(file_name_suffix);
    file_name = cell(file_num, 1);
    for i = 1:file_num
        name = strsplit(file_name_suffix(i).name,'.');
        file_name{i,1} = name{1,1};
    end
end

