# Account Deleter program
**GOAL** contact customer service (known forward as "support") of given companies/websites with request to delete account.

## Resources
- https://github.com/vlang/v
- https://www.consumerprivacyact.com/section-1798-105-right-to-deletion/

## My Use Case
- GOAL: quickly delete many (even hundreds) of online accounts.
- FUNCTION: automate "Request for Account Deletion" emails
- CONSIDERATIONS: legality, follow-ups, inability to delete account via email

## Implementation Prototype
- pre-reqs
    - csv of accounts to be deleted
        - format: email,username,company
- program steps
    1. data handling
        - optional: log into email & store senders? - inspo: gh.com/Gobutsu/Conan
        1. ingest accounts CSV
        2. group similiar companies
        3. store
        4. group similiar emails
        5. store
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
    3. uhhh
