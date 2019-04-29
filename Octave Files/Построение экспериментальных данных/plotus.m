clc; clear all; close all;

[check, CURRENT_PATH] = system('pwd;');

[check, SAVE_PATH] = system('cd ../img/; pwd;');

CURRENT_PATH = strsplit(CURRENT_PATH, "\n");

SAVE_PATH = strsplit(SAVE_PATH, "\n");

CURRENT_PATH = strcat(CURRENT_PATH{1}, '/');

SAVE_PATH = strcat(SAVE_PATH{1}, '/');

DELIMETER = ',';

SAVE_FORMAT = '.jpg';

[check, file_path_3TD] = system('cd ../TorusStatistics; path=$(pwd); for folder in $(ls $path/); do find $path/$folder -name "*.3TD"; done');
[check, file_name_3TD] = system('cd ../TorusStatistics; path=$(pwd); for folder in $(ls $path/); do cd $path/$folder; ls *.3TD; done');

file_path_3TD = strsplit(file_path_3TD, "\n");
file_name_3TD = strsplit(file_name_3TD, "\n");

file_path_3TD = file_path_3TD(1:size(file_path_3TD)(2)-1);
file_name_3TD = file_name_3TD(1:size(file_name_3TD)(2)-1);

choose = 1;

printf("CURRENT_PATH=%s\nSAVE_PATH=%s\n", CURRENT_PATH, SAVE_PATH);

saved = input("0 -- Save to file\n1 -- Show plot\nYour choose: ");

if saved == 1
  saved = false
  
  while(choose ~= 0 & choose > 0)
    clc; close all;
  
    for i=1:length(file_name_3TD)
  
      printf("%2d: %02s\n", i, file_name_3TD{i});
    
    endfor
    
    for i=1:length(file_name_UVT)
  
      printf("%2d: %02s\n", (50 + i), file_name_UVT{i});
    
    endfor
  
    printf('\nExit: 0\n');
  
    choose = input('Enter your choose, please: ');
    
    file_name_3TD{choose} = sprintf("%2s\t<--viewed",file_name_3TD{choose}); 
  
    if choose ~= 0 && choose > 0
  
      paltusM(file_path_3TD{choose}, file_name_3TD{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
      paltusC(file_path_3TD{choose}, file_name_3TD{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
      
      paltusV(file_path_3TD{choose}, file_name_3TD{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
      ask_continue = input('Press any button to continue ', 's');

    endif

  endwhile
elseif saved == 0
  saved = true;
  
  for i=1:length(file_path_3TD)
    paltusM(file_path_3TD{i}, file_name_3TD{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);

    printf("Markers%02s\t<--saved\n", file_name_3TD{i});
    
    paltusC(file_path_3TD{i}, file_name_3TD{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
    printf("Center%02s\t<--saved\n", file_name_3TD{i});    
    
    paltusV(file_path_3TD{i}, file_name_3TD{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
  
    printf("Velocities%02s\t<--saved\n", file_name_3TD{i});
    
  endfor
endif