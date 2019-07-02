clc; clear all; close all;

[check, CURRENT_PATH] = system('pwd;');

CURRENT_PATH = strsplit(CURRENT_PATH, "\n");
CURRENT_PATH = strcat(CURRENT_PATH{1}, '/');

DELIMETER = ',';

[check, file_path_3TD] = system('cd ../../TorusStatistics; path=$(pwd); for folder in $(ls $path/); do find $path/$folder -name "*.3TD"; done');
[check, file_name_3TD] = system('cd ../../TorusStatistics; path=$(pwd); for folder in $(ls $path/); do cd $path/$folder; ls *.3TD; done');

file_path_3TD = strsplit(file_path_3TD, "\n");
file_name_3TD = strsplit(file_name_3TD, "\n");

file_path_3TD = file_path_3TD(1:size(file_path_3TD)(2)-1);
file_name_3TD = file_name_3TD(1:size(file_name_3TD)(2)-1);

printf("CURRENT_PATH=%s\n", CURRENT_PATH);
  
for i=1:length(file_path_3TD)
  d = processing(file_path_3TD{i}, file_name_3TD{i}, DELIMETER);
  
  printf("Markers%02s\t<--saved\n", file_name_3TD{i});

  dlmwrite("database.csv", d, "-append");
  fflush(1); 
endfor