#!/bin/bash

# Log file to store results
LOG_FILE="driver_checker.log"

# Ensure the log file exists
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# Main script logic
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <new|get|list>"
    exit 1
fi

if [ "$1" = "new" ]; then
    echo "Enter your name:"
    read name
    echo "Enter your age:"
    read age
    echo "Enter your vision rate (1-6):"
    read vision_rate

    # Check eligibility
    if [ "$age" -ge 18 ] && [ "$vision_rate" -ge 4 ]; then
        result="eligible"
    else
        result="not eligible"
    fi

    # Save the result to the log file
    echo "$name:$age:$vision_rate:$result" >> "$LOG_FILE"

    # Print the result
    echo "You are $result for a driver's license."

elif [ "$1" = "get" ]; then
    echo "Enter the name of the user:"
    read search_name

    # Search the log file
    search_result=$(grep "^$search_name:" "$LOG_FILE" | tail -n 1)
    if [ -z "$search_result" ]; then
        echo "No record found for $search_name."
    else
        result=$(echo "$search_result" | cut -d ':' -f 4)
        echo "$search_name:$result"
    fi

elif [ "$1" = "list" ]; then
    if [ ! -s "$LOG_FILE" ]; then
        echo "No records found."
    else
        while IFS=: read -r name _ _ result; do
            echo "$name:$result"
        done < "$LOG_FILE"
    fi

else
    echo "Invalid option. Use 'new', 'get', or 'list'."
    exit 1
fi

