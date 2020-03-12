class HomeController < ApplicationController
  def index
    # flash[:alert] = "We will be open up to and including Christmas Eve, then closed until Tue 14th of Jan." unless Date.today > Date.new(2020, 1, 13)
    link = 'https://bawbawfoodhub.org.au/jobs/general-manager'
    flash.now[:alert] = %Q[We're hiring for the position of <strong><a href="#{link}">General Manager</a></strong> at the hub!].html_safe
  end

  def newsletters
    @campaigns = Mailchimp::Api.get_campaigns["campaigns"].sort_by{ |c| c["send_time"] }.reverse
  end

  def questions
    @faq_groups = FaqGroup.preload(:faqs)
  end

  private

  def cms_page(slug)
    return unless @cms_site.present?
    @cms_site.pages.published.find_by(slug: slug)
  end
end
