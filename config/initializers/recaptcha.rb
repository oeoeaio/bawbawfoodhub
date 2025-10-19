Recaptcha.configure do |config|
  config.site_key  = Rails.application.secrets.recaptcha_site_key
  config.enterprise = true
  config.enterprise_api_key = Rails.application.secrets.recaptcha_enterprise_api_key
  config.enterprise_project_id = Rails.application.secrets.recaptcha_enterprise_project_id
end
