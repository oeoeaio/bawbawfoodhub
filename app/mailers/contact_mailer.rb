class ContactMailer < ActionMailer::Base
  def query(contact)
    @contact = contact
    mail(
      to: Rails.application.secrets.admin_email,
      from: Rails.application.secrets.admin_email,
      reply_to: "\"#{contact.name}\" <#{contact.email}>",
      subject: contact.subject
    )
  end
end