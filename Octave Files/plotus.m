clc; clear all; close all;

SAVE_PATH = '/home/dezodemius/Documents/Diploma/img/';

DELIMETER = ',';

SAVE_FORMAT = '.bmp';

[check, file_path] = system('path="../TorusStatistics/"; for folder in $(ls $path); do find $path$folder -name "*.3TD"; done');
[check, file_name] = system('path="../TorusStatistics/"; for folder in $(ls $path); do cd $path$folder; ls *.3TD; done');
  
file_path = strsplit(file_path, "\n");
file_name = strsplit(file_name, "\n");

file_path = file_path(1:size(file_path)(2)-1);
file_name = file_name(1:size(file_name)(2)-1);

choose = 1;

saved = input("0 -- Save to file\n1 -- Show plot\nYour choose: ");

if saved == 1
  saved = false
  
  while(choose ~= 0 & choose > 0)
    clc; close all;
  
    for i=1:length(file_name)
  
      printf("%2d: %02s\n", i, file_name{i});
    
    endfor
  
    printf('\nExit: 0\n');
  
    choose = input('Enter your choose, please: ');
  
    file_name{choose} = sprintf("%2s\t<--viewed",file_name{choose}); 
  
    if choose ~= 0 && choose > 0
  
      paltusM(file_path{choose}, file_name{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
      paltusC(file_path{choose}, file_name{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
      
      paltusV(file_path{i}, file_name{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
      ask_continue = input('Press any button to continue ', 's');

    endif
  
  endwhile
elseif saved == 0
  saved = true;
  
  for i=1:length(file_path)
    paltusM(file_path{i}, file_name{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);

    printf("Markers%02s\t<--saved\n", file_name{i});
    
    paltusC(file_path{i}, file_name{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
    printf("Center%02s\t<--saved\n", file_name{i});    
    
    paltusV(file_path{i}, file_name{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
  
    printf("Velocities%02s\t<--saved\n", file_name{i});
    
  endfor
endif