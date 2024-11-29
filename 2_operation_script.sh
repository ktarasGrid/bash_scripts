#!/bin/bash

# Default debug to 0
debug=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -o)
            op="$2"
            shift 2
            ;;
        -n)
            shift
            while [[ "$1" != "" && "$1" != "-"* ]]; do
                nums+=("$1")
                shift
            done
            ;;
        -d)
            debug=1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate operation
if [[ ! "$op" =~ ^[\+\-\*\%]$ ]]; then
    echo "Invalid operation: $op"
    exit 1
fi

# Check if numbers are provided
if [ ${#nums[@]} -eq 0 ]; then
    echo "No numbers provided"
    exit 1
fi

# Perform calculation
result=${nums[0]}
for ((i=1; i<${#nums[@]}; i++)); do
    case "$op" in
        "+") result=$((result + nums[i])) ;;
        "-") result=$((result - nums[i])) ;;
        "*") result=$((result * nums[i])) ;;
        "%") result=$((result % nums[i])) ;;
        *) 
            echo "Invalid operation: $op"
            exit 1
            ;;
    esac
done

# Output the result
echo "Result: $result"

# Debug information
if [[ $debug -eq 1 ]]; then
    echo "User: $(whoami)"
    echo "Script: $0"
    echo "Operation: $op"
    echo "Numbers: ${nums[*]}"
fi
