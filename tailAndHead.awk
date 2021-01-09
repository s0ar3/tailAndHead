#!/usr/bin/awk -f

function printing_lines(numberLines) {
    for (i=0; i<numberLines; i++) {
        printf "%s", "-"
    }
    printf "\n"
}

function print_arr(starting, ending) {
    for (i=starting; i<=ending; i++) {
        printf "%s\n", all[i];
    }
    printing_lines(70);
    exit;
}

BEGIN {
    printing_lines(70)
    check=0
    for (i=0; i<ARGC; i++) {
        if (((ARGC-1) == 2) && ARGV[i+1] ~ /[0-9]{1,}/ && ARGV[i+2] ~ /[0-9]{1,}/  ) {
            start=ARGV[i+1]; delete ARGV[i+1];
            end=ARGV[i+2]; delete ARGV[i+2];
            check=1
        } else if (ARGV[i] == "-l") {
            given_option="1"; delete ARGV[i];
            desired_lines=ARGV[i+1]; delete ARGV[i+1];
            check=1
        } else if (ARGV[i] == "-r") {
            start=ARGV[i+1]; delete ARGV[i];
            end=ARGV[i+2]; delete ARGV[i+1];
            delete ARGV[i+2];
            check=1
        } else if (ARGV[i] == "-f") {
            start=1; delete ARGV[i];
            end=ARGV[i+1]; delete ARGV[i+1];
            check=1
        } 
    }

    if (check == 0 ) {
        printf "\n\033[31m%s\033[0m\n\n", "Options we can use: -> (-r for range, like ./tailAndHead.awk given_file -r 2 5 where 2 and 5 are start and end lines)\n \
                   -> (-l for last lines, like ./tailAndHead.awk given_file -l 2, where 2 are the last two lines)\n \
                   -> (-f same as above but first lines like -f 5 where 5 are 5 first lines) \n \
                   -> (last options can be used to parse a command output and extract range of lines using command | and script with range input)";
        exit
    }
}   

{ all[FNR]=$0 }

END {
    if (given_option == "1") {
        if (desired_lines > FNR) {
            printf "\n%s %s\n\n", "\033[31mERROR\033[0m - the number of lines in the standard input is", FNR
            printing_lines(70);        
            exit
        } else if (last_lines < FNR) {
            last_lines=(FNR - (desired_lines - 1));
            print_arr(last_lines, FNR);
        } 
    }
    
    if ((start > FNR) || (start <= 0)) {
        printf "\n\033[31mERROR Number of lines detected in standard input/file is %d.\033[0m\n\
***We need another interval from you but starting line needs to be lower than size detected and mentioned above and not bellow 1.\n\n", length(all);
        printing_lines(70);
    } else {
        if (end > FNR) {
            print_arr(start, FNR);
        } else {
            print_arr(start, end);
        }
    }
}