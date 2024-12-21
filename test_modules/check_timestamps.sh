#!/bin/bash

check_timestamps() 
{
    # Ensure the script is run with an argument (the executable path)
    if [ -z "$1" ]; then
        echo "Usage: ./run_philos.sh <path_to_philo_executable>"
        exit 1
    fi

    # Path to the executable
    EXECUTABLE=$1
	local nbr_errors=0

    # Loop through values of X (10 to 200, step 10)
    for ((nbr_philos=190; nbr_philos<=200; nbr_philos+=10)); do
        echo "Running with $nbr_philos philosophers..."
        python3 check_timestamps.py "$EXECUTABLE" "$nbr_philos" 800 200 200 5
        if [ $? -ne 0 ]; then
            echo "Test failed for $nbr_philos philosophers."
            exit 1
			nbr_errors=$((nbr_errors+1))
        fi
    done
    #based on the number of errors, print the appropriate message
	if [ $nbr_errors -ne 0 ]; then
		printf "${GREEN}${BOLD}All tests passed!${RESET}\n"
		exit 1
	else
		printf "${RED}${BOLD}Some tests failed!${RESET}\n"
	fi
}
# # Ensure the script is run with an argument (the executable path)
# if [ -z "$1" ]; then
#     echo "Usage: ./run_philos.sh <path_to_philo_executable>"
#     exit 1
# fi

# # Path to the executable
# EXECUTABLE=$1

# # Loop through values of X (10 to 200, step 10)
# for ((nbr_philos=10; nbr_philos<=200; nbr_philos+=10)); do
#     echo "Running with $nbr_philos philosophers..."
#     python3 check_timestamps.py "$EXECUTABLE" "$nbr_philos" 800 200 200 5
#     if [ $? -ne 0 ]; then
#         echo "Test failed for $nbr_philos philosophers."
#         exit 1
#     fi
# done

# echo "All tests passed!"
