# Account Deleter program

#### PROJECT CLOSED REFLECTION:
- Reasoning for project closure:
	- The method as designed is likely to be "filtered as spam by the companies email filters."
	- Implementing a Playwright script would be tedious as every website would need a different script.
	- This effort could therefore instead be better spent manually deleting each account.
- Reflections:
	- Using Mermaid.js for the first time, I found it to be a hassle. Excalidraw serves much better for diagramming.

## Outlining
**GOAL** contact customer service (known forward as "support") of given companies/websites with request to delete account.
![Program Steps.excalidraw.svg]

## Resources
- information:
    - https://www.consumerprivacyact.com/section-1798-105-right-to-deletion/
- possible contacts:
    - Thorin Klosowski - Wirecutter @ New York Times
    - DeleteMe
    - unroll.me
- notes:
    - college emails, from Handshake: "If you no longer have access to the Student email address associated with your account, please get in touch with your university's career center to have it deleted."

## My Use Case
- GOAL: quickly delete many (even hundreds) of online accounts.
- FUNCTION: automate "Request for Account Deletion" emails
- CONSIDERATIONS: legality, follow-ups, inability to delete account via email, non-cooperation, multiple support addresses for single company

- SCOPE CREEP: 
    - one user email vs many
    - pre-sorted vs sorting
    - pre-compacted vs compacting
## Implementation Prototype
- pre-reqs
    - accounts.csv
        - format: email,username,company
    - email_template
        - variables: support_emails, user_email, company_name, username, signature_name
- program steps
    1. data handling
        - variables:
            - uhh
        - optional: log into user_email & store senders? - inspo: gh.com/Gobutsu/Conan
        1. ingest email_template
        2. store email_template
        3. ingest accounts.csv
        4. store account_list
    2. support email gathering
        1. collect support emails of companies listed
            1. check sources:
                - dns registry?
                - open dataset?
                    - data.gov, kaggle datasets
                - business directories!
                    - yelp fusion API, yellow pages?, chamber of commerce?
                - web scrape?
                - gh repos?
                    - aint no way
                    - https://github.com/justdeleteme/justdelete.me/blob/master/sites.json
                - online search 
                    - i.e. site:blizzard.com "support email"
                        - or "contact"...?
            2. confirm email validity?
        2. store in company_list
    3. make emails 
        1. construct sample using template
            1. choose first company
            2. replace variables
        2. output email for user preview
        3. user confirmation
        4. construct all emails
            1. iterate company_list
                1. new email
                    - replace variables
                2. store to email_list
                3. iterate
    4. send emails
        1. user confirmation
        2. iterate email_list
            1. send
            2. print success/fail
            3. iterate
