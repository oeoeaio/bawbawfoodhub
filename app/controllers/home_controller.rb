class HomeController < ApplicationController

  def newsletters
    @campaigns = Mailchimp::Api.get_campaigns["campaigns"].sort_by{ |c| c["send_time"] }.reverse
  end

  def questions
    @faq_groups = FaqGroup.preload(:faqs)
  end
end
