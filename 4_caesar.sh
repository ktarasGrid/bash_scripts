#!/bin/bash

# Initialize variables
shift_amount=
input_file=
output_file=

# Parse command-line arguments
while getopts ":s:i:o:" opt; do
  case $opt in
    s)
      shift_amount="$OPTARG"
      ;;
    i)
      input_file="$OPTARG"
      ;;
    o)
      output_file="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Validate shift amount
if [[ -z "$shift_amount" ]]; then
  echo "Shift amount (-s) is required."
  exit 1
fi

if ! [[ "$shift_amount" =~ ^[0-9]+$ ]]; then
  echo "Shift amount (-s) must be an integer."
  exit 1
fi

if [ "$shift_amount" -lt 0 ] || [ "$shift_amount" -gt 25 ]; then
  echo "Shift amount (-s) must be between 0 and 25."
  exit 1
fi

# Validate input and output files
if [[ -z "$input_file" ]]; then
  echo "Input file (-i) is required."
  exit 1
fi

if [[ -z "$output_file" ]]; then
  echo "Output file (-o) is required."
  exit 1
fi

if [ ! -f "$input_file" ]; then
  echo "Input file does not exist."
  exit 1
fi

# Define alphabets
UPPER='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
LOWER='abcdefghijklmnopqrstuvwxyz'

# Calculate shifted alphabets
shift="$shift_amount"
UPPER_SHIFTED="${UPPER:$shift}${UPPER:0:$shift}"
LOWER_SHIFTED="${LOWER:$shift}${LOWER:0:$shift}"

# Perform the Caesar cipher shift and write to output file
cat "$input_file" | tr "${UPPER}${LOWER}" "${UPPER_SHIFTED}${LOWER_SHIFTED}" > "$output_file"

