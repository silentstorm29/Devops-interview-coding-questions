# "Given a string, write a script to validate if it is an email address based on the following criteria:

# It should contain exactly one '@' symbol.
# The domain part after '@' should have at least one period (.), and the top-level domain (e.g., .com, .org, .net) should be 2-6 characters long.
# The local part (before @) should not contain any special characters except . or _.
# Email should not start or end with . or _.

# Additionally, suggest ways to integrate this validation into a CI/CD pipeline for automated testing."



#email = abc@gmail.com
#1. getting the email address and checking if there is a '.' and '@' is there,
import sys

email = input()

#2. it should not be starting or ending with the '.' and '_'
if email[0] in "@._" or email[-1] in "@._":
    sys.exit("Exiting: string starts and ends with a special character")
else:

    #checking if @ has more than one occurrence:
    count_at = 0
    i = 1
    count_at = email.count('@')
    count_dot = email.count('.')
    if count_at > 1:
        sys.exit("Exiting: string starts and ends with a special character")
    if count_dot > 1:
        sys.exit("Exiting: string starts and ends with a special character")

    #3. splitting my email based on 2 delimiters, @ and .
    local_name, rest = email.split('@', 1)
    provider, top_name = rest.split('.', 1)
   # print(local_name, provider, top_name)
    len_top_name = len(top_name)
    print(len_top_name)
  #  print(len_top_name)
    if len_top_name < 2 or len_top_name > 6:
        sys.exit("Exiting: string has not correct domain")
    elif not top_name.isalpha():
        sys.exit(f"Invalid domain '{email}': contains non-alphabetic characters")
    else:
        print("This is a perfect domain")








            





