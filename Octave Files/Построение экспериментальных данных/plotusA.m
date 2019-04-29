clc; clear all; close all;

[check, CURRENT_PATH] = system('pwd;');

[check, SAVE_PATH] = system('cd ../img/; pwd;');

CURRENT_PATH = strsplit(CURRENT_PATH, "\n");

SAVE_PATH = strsplit(SAVE_PATH, "\n");

CURRENT_PATH = strcat(CURRENT_PATH{1}, '/');

SAVE_PATH = strcat(SAVE_PATH{1}, '/');

DELIMETER = ',';

SAVE_FORMAT = '.jpg';

[check, file_path] = system('cd ../TorusStatistics; path=$(pwd); for folder in $(ls $path/); do find $path/$folder -name "*.UVT"; done');
[check, file_name] = system('cd ../TorusStatistics; path=$(pwd); for folder in $(ls $path/); do cd $path/$folder; ls *.UVT; done');

file_path = strsplit(file_path, "\n");
file_name = strsplit(file_name, "\n");

file_path = file_path(1:size(file_path)(2)-1);
file_name = file_name(1:size(file_name)(2)-1);

FILE = dlmread(file_path{1}, DELIMETER);


abg = [FILE(:,  19), FILE(:,  22), FILE(:,  25), FILE(:,  20), FILE(:,  23), FILE(:,  26), FILE(:,  21), FILE(:,  24), FILE(:,  27)];
choose = 1;

printf("CURRENT_PATH=%s\nSAVE_PATH=%s\n", CURRENT_PATH, SAVE_PATH);

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
  
      paltusA(file_path{choose}, file_name{choose}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);
    
      ask_continue = input('Press any button to continue ', 's');

    endif

  endwhile
elseif saved == 0
  saved = true;
  
  for i=1:length(file_path)
    paltusA(file_path{i}, file_name{i}, DELIMETER, SAVE_PATH, SAVE_FORMAT, saved);

    printf("ABG%02s\t<--saved\n", file_name{i});    
  endfor
endif