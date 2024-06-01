#updated to include support for multiple user accounts

require 'csv'
require 'net/smtp'
require 'nokogiri'
require 'open-uri'
require 'logger'

# Step 1: Read the list of companies from a file
def read_companies(file_path)
  companies = []
  File.open(file_path, 'r') do |file|
    file.each_line do |line|
      companies << line.strip.downcase
    end
  end
  companies
end

# Step 2: Read the user accounts from a CSV file
def read_user_accounts(csv_path)
  user_accounts = {}
  CSV.foreach(csv_path, headers: true) do |row|
    company_name = row['company'].strip.downcase
    user_email = row['user_email'].strip
    user_accounts[company_name] ||= []
    user_accounts[company_name] << user_email
  end
  user_accounts
end

# Step 3: Get the support email addresses from a precompiled CSV
def get_support_emails_from_csv(companies, csv_path)
  support_emails = {}
  CSV.foreach(csv_path, headers: true) do |row|
    company_name = row['company'].strip.downcase
    if companies.include?(company_name)
      support_emails[company_name] = row['support_email']
    end
  end
  support_emails
end

# Step 4: Web scraping to find support email addresses
def get_support_email_from_website(company_name)
  search_query = "#{company_name} support email"
  search_url = "https://www.google.com/search?q=#{URI.encode(search_query)}"
  user_agent = "Mozilla/5.0"

  begin
    doc = Nokogiri::HTML(URI.open(search_url, 'User-Agent' => user_agent))
    
    # A very simple heuristic to find an email in the page
    email = doc.css('a[href^="mailto:"]').first
    email_address = email ? email['href'].split(':')[1] : nil
    email_address
  rescue => e
    puts "Failed to scrape email for #{company_name}: #{e.message}"
    nil
  end
end

# Step 5: Compose the email
def compose_email(to_address, company_name, user_email)
  from_address = "your_email@example.com"
  subject = "Request for Account Deletion"
  body = <<-BODY
  Dear #{company_name.capitalize} Support,

  I would like to request the deletion of my account associated with the email: #{user_email}.

  Best regards,
  #{user_email.split('@').first.capitalize}
  BODY

  { from: from_address, to: to_address, subject: subject, body: body }
end

# Step 6: Send the email
def send_email(email, smtp_settings)
  message = <<~MESSAGE
    From: #{email[:from]}
    To: #{email[:to]}
    Subject: #{email[:subject]}

    #{email[:body]}
  MESSAGE

  Net::SMTP.start(smtp_settings[:address], smtp_settings[:port], smtp_settings[:domain], smtp_settings[:user_name], smtp_settings[:password], :plain) do |smtp|
    smtp.send_message message, email[:from], email[:to]
  end
end

# Step 7: Main function to tie everything together
def main(companies_file, user_accounts_file, email_db, smtp_settings)
  logger = Logger.new('email_log.txt')
  companies = read_companies(companies_file)
  user_accounts = read_user_accounts(user_accounts_file)
  support_emails = get_support_emails_from_csv(companies, email_db)

  companies.each do |company|
    email = support_emails[company]

    unless email
      puts "Trying to scrape email for #{company}"
      email = get_support_email_from_website(company)
    end

    if email
      user_accounts[company]&.each do |user_email|
        email_msg = compose_email(email, company, user_email)
        begin
          send_email(email_msg, smtp_settings)
          logger.info("Email sent to #{company} support at #{email} for user #{user_email}")
        rescue => e
          logger.error("Failed to send email to #{company} support at #{email} for user #{user_email}: #{e.message}")
        end
      end
    else
      logger.error("Could not find support email for #{company}")
    end
  end
end

# Example usage
if __FILE__ == $0
  companies_file = 'companies.txt'
  user_accounts_file = 'user_accounts.csv'
  email_db = 'support_emails.csv'
  smtp_settings = {
    address: 'smtp.example.com',
    port: 587,
    domain: 'example.com',
    user_name: 'your_email@example.com',
    password: 'your_password'
  }

  main(companies_file, user_accounts_file, email_db, smtp_settings)
end
