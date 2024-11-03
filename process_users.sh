#!/bin/bash

# Function to check if an email is a valid FQDN email
is_valid_email() {
    local email=$1
    # Regex pattern to match a valid FQDN email address
    local pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    [[ $email =~ $pattern ]]
}

# Function to process the user data file
process_user_data() {
    local filename=$1
    local line_number=0

    while IFS=, read -r name email id; do
        # Skip the header line
        if (( line_number == 0 )); then
            ((line_number++))
            continue
        fi

        # Trim leading/trailing whitespace from email and id
        email=$(echo "$email" | xargs)
        id=$(echo "$id" | xargs)

        # Check if email and id are specified and id is a valid number
        if [[ -z $email || -z $id || ! $id =~ ^[0-9]+$ ]]; then
            echo "Warning: Invalid entry ${name}, ${email}, ${id}"
            continue
        fi

        # Validate email and determine if user ID is even or odd
        if is_valid_email "$email"; then
            if (( id % 2 == 0 )); then
                echo "The $id of $email is even number."
            else
                echo "The $id of $email is odd number."
            fi
        else
            echo "Warning: Invalid email ${email} in entry ${name}, ${email}, ${id}"
        fi

        ((line_number++))
    done < "$filename"
}

# Usage example
filename='user_data.txt'
process_user_data "$filename"
