class HomeController < ApplicationController
  def index
    flash[:alert] = "We will be closed for the Grand Final Day public holiday. Friday 27th of September." unless Date.today > Date.new(2019, 9, 27)
  end

  def newsletters
    @campaigns = Mailchimp::Api.get_campaigns["campaigns"].sort_by{ |c| c["send_time"] }.reverse
  end

  def questions
    @faq_groups = FaqGroup.preload(:faqs)
  end
end
