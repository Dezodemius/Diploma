clc; clear all; close all;

SAVE_PATH = '/home/dezodemius/Documents/Diploma/img/';

DELIMETER = ',';

SAVE_FORMAT = '.bmp';

#paltus(PATH, file_name, delimeter)
[hz_chto_eto, file_path] = system('path="/home/dezodemius/Documents/Diploma/TorusStatistics/"; for folder in $(ls $path); do find $path$folder -name "*.3TD"; done');
[hz_chto_eto, file_name] = system('path="/home/dezodemius/Documents/Diploma/TorusStatistics/"; for folder in $(ls $path); do cd $path$folder; ls *.3TD; done');
  
file_path = strsplit(file_path, "\n");
file_name = strsplit(file_name, "\n");

file_path = file_path(1:size(file_path)(2)-1);
file_name = file_name(1:size(file_name)(2)-1);

%{
for i=1:length(file_path)
  paltus(file_path{i}, file_name{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT)
  printf("%02s is saved\n", file_name{i});
endfor
%}
choose = 1;

while(choose ~= 0 & choose > 0)
  clc; close all;
    
  for i=1:length(file_name)
    printf("%2d: %02s\n", i, file_name{i});
  endfor
  
  printf('\nExit: 0\n');
  
  choose = input('Enter your choose, please: ');
  
  file_name{choose} = strcat(file_name{choose}, '---viewed'); 
  
  saved = false;
  if choose ~= 0 && choose > 0
    paltus(file_path{choose}, file_name{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved) 
    ask_continue = input('Press any button to continue ', 's');
  endif
  
endwhile