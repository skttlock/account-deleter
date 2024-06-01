
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

# Step 2: Get the support email addresses from a precompiled CSV
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

# Step 2b: Web scraping to find support email addresses
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

# Step 3: Compose the email
def compose_email(to_address, company_name)
  from_address = "your_email@example.com"
  subject = "Request for Account Deletion"
  body = <<-BODY
  Dear #{company_name.capitalize} Support,

  I would like to request the deletion of my account.

  Best regards,
  Your Name
  BODY

  { from: from_address, to: to_address, subject: subject, body: body }
end

# Step 4: Send the email
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

# Step 5: Main function to tie everything together
def main(companies_file, email_db, smtp_settings)
  logger = Logger.new('email_log.txt')
  companies = read_companies(companies_file)
  support_emails = get_support_emails_from_csv(companies, email_db)

  companies.each do |company|
    email = support_emails[company]

    unless email
      puts "Trying to scrape email for #{company}"
      email = get_support_email_from_website(company)
    end

    if email
      email_msg = compose_email(email, company)
      begin
        send_email(email_msg, smtp_settings)
        logger.info("Email sent to #{company} at #{email}")
      rescue => e
        logger.error("Failed to send email to #{company} at #{email}: #{e.message}")
      end
    else
      logger.error("Could not find email for #{company}")
    end
  end
end

# Example usage
if __FILE__ == $0
  companies_file = 'companies.txt'
  email_db = 'support_emails.csv'
  smtp_settings = {
    address: 'smtp.example.com',
    port: 587,
    domain: 'example.com',
    user_name: 'your_email@example.com',
    password: 'your_password'
  }

  main(companies_file, email_db, smtp_settings)
end
