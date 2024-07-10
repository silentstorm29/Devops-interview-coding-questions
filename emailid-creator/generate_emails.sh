
####### Writing a script to generate email ID's based on the list provided names.txt and appending all emails in a file emails.txt
#!/bin/bash

# Checking if the argument (file name) is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi

# Declaring file name to pass it as an argument
file_name="$1"

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "File $file_name does not exist."
    exit 1
fi

# Check if the file exists
if [ ! -f "email.txt" ]; then
    touch email.txt
fi

# Reading each name from the file and processing it
while IFS= read -r name; do
    # Convert name to lowercase
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

    # Generate the initial email ID for the user
    email=$(echo "$name" | awk '{OFS=""; print $1, ".", $2, "@domain.com"}')

    # Extract the base name and the domain part
    base_name=$(echo "$email" | cut -d'@' -f1)
    domain=$(echo "$email" | cut -d'@' -f2)

    # Check if the email exists in the email list
    if grep -q "^$email$" email.txt; then
        # Extract the username part (before the '@')
        username=$(echo "$email" | cut -d'@' -f1)

        # Extract the name and check if it contains a number
        if [[ "$username" =~ ([a-zA-Z]+)([0-9]*)\. ]]; then
            base=${BASH_REMATCH[1]}
            number=${BASH_REMATCH[2]}
            if [[ -z "$number" ]]; then
                number=1
            else
                number=$((number + 1))
            fi
            # Increment the number to find the next available email
            new_email="${base}${number}.${username#*.}@${domain}"
            while grep -q "^${new_email}$" email.txt; do
                number=$((number + 1))
                new_email="${base}${number}.${username#*.}@${domain}"
            done
            email=$new_email
        else
            # If no number is found in the username, just add 1
            email="${username}1@${domain}"
        fi
    fi

    # Adding the generated email to email.txt
    echo "$email" >> email.txt

done < "$file_name"

# Displaying the content of email.txt
cat email.txt
