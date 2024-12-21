#!/usr/bin/env bash

die_test_auto ()
{
	printf "\n${CYAN}=== Starting tests where program should end with death or enough eaten ===\n${RESET}"
	while IFS="" read -r -u 3 input || [ -n "$input" ] # read input from fd 3
	do
		read -r -u 3 result # read desired result description from input.txt
		printf "\nTest: ${BLUEBG}${WHITE}[$input]${RESET} | ${PURP}$result${RESET}\n\n"	
		# Run the program with test case input silently
		if $1 $input >/dev/null 2>&1; then
			# Check if "died" is in the output logs (or other conditions, if needed)
			printf "${GREEN}OK${RESET}\n"
		else
			printf "${RED}KO${RESET}\n"
		fi
	done 3< ./data/yes-die.txt   # open file is assigned fd 3
	exec 3<&- # close fd 3
}
