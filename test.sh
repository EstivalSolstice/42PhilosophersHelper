#!/bin/bash

source ./load_scripts.sh
source ./colors.sh

# Counters
PASS=0
FAIL=0
TESTS=0

# checks params. If none given, assumes philo executable is in same directory as tester directory.
if [ "$#" -gt 1 ]; then
	printf "Too many parameters. Please only provide path to philo executable.\n"
	exit
elif [ "$#"  -lt 1 ]; then
	set $1 ../philo
fi

# checks if given executable path and file is valid.
if [ ! -f "$1" ]; then
	printf "$1 not found or invalid file. Please (re)make philo executable first.\n"
	exit
fi

PROGRESS_BAR_WIDTH=50  # progress bar length in characters

draw_progress_bar() {
  # Arguments: current value, max value, unit of measurement (optional)
  local __value=$1
  local __max=$2
  local __unit=${3:-""}	# if unit is not supplied, do not display it

  # Calculate percentage
  if (( $__max < 1 )); then __max=1; fi # anti zero division protection
  local __percentage=$(( 100 - ($__max*100 - $__value*100) / $__max ))

  # Rescale the bar according to the progress bar width
  local __num_bar=$(( $__percentage * $PROGRESS_BAR_WIDTH / 100 ))

  # Draw progress bar
  printf "["
  for b in $(seq 1 $__num_bar); do printf "#"; done
  for s in $(seq 1 $(( $PROGRESS_BAR_WIDTH - $__num_bar ))); do printf " "; done
  printf "] $__percentage%% ($__value / $__max $__unit)\r"
}

choose_test() {
	read -rn1 -p $'\nChoose test to run:\t
	[0] all tests\t
	[1] die tests\t
	[2] no-die tests (can take a while)\t
	[3] no-die tests (auto)\t
	[4] all tests (auto)\t
	[5] check data races && deadlocks \t
	[6] check invalid input (auto)\t
	[7] check timestamps \t
	[ESC] exit tester\n\n' choice
    printf "\n"
    case $choice in
        0) die_test "$1" && no_die_test "$1";;
        1) die_test "$1" ;;
        2) no_die_test "$1" ;;
		3) no_die_test_auto "$1" ;;
		4) check_invalid_inputs "$1" && check_limited_meals "$1" && 
			die_test_auto "$1" && no_die_test_auto "$1";;
		# 4) check_limited_meals "$1";;
		5) run_helgrind "$1";;
		6) check_invalid_inputs "$1";;
        7) check_timestamps "$1";;
        $'\e') exit 0 ;;
        *) printf "${RED}Invalid choice\n${RESET}"; choose_test "$1" ;;
    esac
}

printf "${BOLD}\n💭 The Lazy Philosophers Tester 💭\n${RESET}"
printf "\nThis tester allows you to test:\n\n"
printf "\t1. when your program should stop on death or when all philos have eaten enough\n"
printf "\t- to be checked manually by the user, based on the expected result listed in yes-die.txt.\n\n"
printf "\t2. when no philosophers should die\n"
printf "\t- this is checked automatically if the program runs for x seconds (default 10) without death.\n"
choose_test "$1"
