#!/bin/bash

# Initialize variables
input_file=""
output_file=""
a_word=""
b_word=""
transformations=()

# Parse command-line arguments
args=("$@")
i=0
while [ $i -lt $# ]; do
  case "${args[$i]}" in
    -v)
      transformations+=("swap_case")
      ;;
    -s)
      ((i++))
      if [ $i -ge $# ]; then
        echo "Error: Missing arguments for -s option."
        exit 1
      fi
      a_word="${args[$i]}"
      ((i++))
      if [ $i -ge $# ]; then
        echo "Error: Missing second argument for -s option."
        exit 1
      fi
      b_word="${args[$i]}"
      transformations+=("substitute")
      ;;
    -r)
      transformations+=("reverse_lines")
      ;;
    -l)
      transformations+=("to_lower")
      ;;
    -u)
      transformations+=("to_upper")
      ;;
    -i)
      ((i++))
      if [ $i -ge $# ]; then
        echo "Error: Missing argument for -i option."
        exit 1
      fi
      input_file="${args[$i]}"
      ;;
    -o)
      ((i++))
      if [ $i -ge $# ]; then
        echo "Error: Missing argument for -o option."
        exit 1
      fi
      output_file="${args[$i]}"
      ;;
    *)
      echo "Unknown option or missing argument: ${args[$i]}"
      exit 1
      ;;
  esac
  ((i++))
done

# Validate input and output files
if [ -z "$input_file" ]; then
  echo "Input file (-i) is required."
  exit 1
fi

if [ -z "$output_file" ]; then
  echo "Output file (-o) is required."
  exit 1
fi

if [ ! -f "$input_file" ]; then
  echo "Input file does not exist."
  exit 1
fi

# Read the content of the input file
content=$(cat "$input_file")

# Define transformation functions
swap_case() {
  content="${content//${escaped_a_word}/${escaped_b_word}}"
}

substitute() {
  # Escape special characters in a_word and b_word
  escaped_a_word=$(printf '%s' "$a_word" | sed "s/[.[\*^$(){}?+|/]/\\&/g")
  escaped_b_word=$(printf '%s' "$b_word" | sed "s/[&/\]/\\&/g")
  content="${content//${escaped_a_word}/${escaped_b_word}}"
}

reverse_lines() {
  content=$(echo "$content" | tac)
}

to_lower() {
  content=$(echo "$content" | tr '[:upper:]' '[:lower:]')
}

to_upper() {
  content=$(echo "$content" | tr '[:lower:]' '[:upper:]')
}

# Apply transformations in the order they were specified
for transform in "${transformations[@]}"; do
  $transform
done

# Write the content to the output file
echo "$content" > "$output_file"
