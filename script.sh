#!/bin/bash

# Function to calculate factorial
factorial() {
    if [ $1 -le 1 ]; then
        echo 1
    else
        echo $(( $1 * $(factorial $(( $1 - 1 ))) ))
    fi
}

# Function to display usage instructions
usage() {
    echo "Usage: $0 -f <file> -n <count>"
    echo "  -f <file>  : File containing numbers (one per line)"
    echo "  -n <count> : Number of values to process (must be positive integer)"
    exit 1
}

# Parse command-line options
while getopts ":f:n:" opt; do
    case $opt in
        f)
            file="$OPTARG"
            ;;
        n)
            count="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Check if file and count options are provided
if [ -z "$file" ] || [ -z "$count" ]; then
    echo "Error: Both -f and -n options are required."
    usage
fi

# Validate count is a positive integer greater than zero
if ! [[ $count =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Count (-n) must be a positive integer greater than zero."
    usage
fi

# Check if file exists and is readable
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
    echo "Error: File '$file' does not exist or is not readable."
    exit 1
fi

# Read the first 'count' values from the file
values=()
while IFS= read -r line && [ ${#values[@]} -lt $count ]; do
    # Check if the line is a valid integer
    if [[ $line =~ ^[0-9]+$ ]]; then
        values+=("$line")
    else
        echo "Warning: Skipping non-integer value '$line' in file '$file'."
    fi
done < "$file"

# Calculate factorial of each value and store results
results=()
for value in "${values[@]}"; do
    results+=("Factorial of $value: $(factorial $value)")
done

# Output results
echo "Results:"
for result in "${results[@]}"; do
    echo "$result"
done
