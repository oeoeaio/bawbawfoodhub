class ContactMailer < ActionMailer::Base
  def query(contact)
    @contact = contact
    mail(
      to: Rails.application.secrets.admin_email,
      from: contact.email,
      subject: contact.subject
    )
  end
end