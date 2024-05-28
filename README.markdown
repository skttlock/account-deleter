# Account Deleter program
**GOAL** contact customer service (known forward as "support") of given companies/websites with request to delete account.

## Resources
- information:
    - https://www.consumerprivacyact.com/section-1798-105-right-to-deletion/
- possible contacts:
    - Thorin Klosowski - Wirecutter @ New York Times
    - DeleteMe
    - ...

## My Use Case
- GOAL: quickly delete many (even hundreds) of online accounts.
- FUNCTION: automate "Request for Account Deletion" emails
- CONSIDERATIONS: legality, follow-ups, inability to delete account via email

- SCOPE CREEP: 
    - one user email vs many
    - pre-sorted vs sorting
## Implementation Prototype
- pre-reqs
    - accounts.csv
        - format: email,username,company
    - email_template
        - variables: support_email, user_email, company_name, username, signature_name
- program steps
    1. data handling
        - optional: log into user_email & store senders? - inspo: gh.com/Gobutsu/Conan
        1. ingest email_template
        2. store
        3. ingest accounts CSV
        4. store 
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
        2. store
    3. email construction
        1. construct from template
