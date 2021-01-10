#!/usr/bin/awk -f

function printLines(number) {
    for (i=1;i<=number;i++) {
        printf "%s", "-"
    }
    printf "\n"
}

function printArr(starting,ending) {
    printLines(80);
    for (i=starting; i<=ending; i++) {
        printf "%s\n", elements[i];
    }
    printLines(80);
}

BEGIN {
    needed_lines=0;
    for (i=1; i<=ARGC;i++) {
        switch ( ARGV[i] ) {
            case "--range" :
                start=ARGV[i+1];
                end=ARGV[i+2];
                option="--range";
                delete ARGV[i]; delete ARGV[i+1]; delete ARGV[i+2];
                break;
            case "--last" :
                needed_lines=ARGV[i+1];
                option="--last";
                delete ARGV[i]; delete ARGV[i+1];
                break;
            case "--count" :
                option="--count";
                delete ARGV[i];
                break;
            case "--first" :
                option="--first";
                start=1; end=ARGV[i+1];
                delete ARGV[i]; delete ARGV[i+1];
                break;
            default :
                option="none";
                delete ARGV[i];
                for (j=i+1; j<=ARGC;j++) {
                    delete ARGV[j];
                }
                exit;
        }
        break;
    }    
}

{ elements[FNR]=$0 }

END {
    switch (option) {
        case "--range" :
            if (end > FNR) {
                end=FNR
            }
            printArr(start,end);
            break;
        case "--last" :
            if (number_lines > FNR) {
                printf "\033[31m%s %d\033[0m\n", "Number of lines in standard input",FNR;
                printArr(1, FNR);
            } else if (number_lines < FNR) {
                lines_printing=(FNR-(needed_lines-1));
                printArr(lines_printing,FNR);
            }
            break;
        case "--count" :
            printLines(80);
            for (i in elements) {
                printf "%s. %s\n",i , elements[i];
            }    
            printLines(80);
            break;
        case "--first" :
            printArr(start,end);
            break;    
        case "none" :
            printLines(80);
            printf "\033[31m%s\033[0m\n", "Options we can use: -> (--range for range, like ./tailAndHead.awk --range 2 5 given_file where 2 and 5 are start and end lines)\n \
                   -> (--last for last lines, like ./tailAndHead.awk --last 2 given_file, where 2 are the last two lines)\n \
                   -> (-first same as above but first lines like --first 5 where 5 are 5 first lines) \n \
                   -> (last options can be used to parse a command output and extract range of lines using command | and script with range input)";
            printLines(80);
            break;    
    }
}