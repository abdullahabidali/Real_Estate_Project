Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # In development, use letter_opener. In production, use real SMTP settings!
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = { from: 'noreply@yourdomain.com' }
end 