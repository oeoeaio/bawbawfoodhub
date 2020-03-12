class HomeController < ApplicationController
  def index
    # flash[:alert] = "We will be open up to and including Christmas Eve, then closed until Tue 14th of Jan." unless Date.today > Date.new(2020, 1, 13)
    file_link = "https://bawbawfoodhub.org.au/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9JYTJWNVNTSWRWR3RwZW1KalVFRm9TREUyV2xOMFZUUkVNVGhVWnprNEJqb0dSVlE2RUdScGMzQnZjMmwwYVc5dVNTSmJhVzVzYVc1bE95Qm1hV3hsYm1GdFpUMGlSMDFmYW05aVgyNWxkM05zWlhSMFpYSmZZV1F1Y0dSbUlqc2dabWxzWlc1aGJXVXFQVlZVUmkwNEp5ZEhUVjlxYjJKZmJtVjNjMnhsZEhSbGNsOWhaQzV3WkdZR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSkloUmhjSEJzYVdOaGRHbHZiaTl3WkdZR093WlUiLCJleHAiOiIyMDIwLTAzLTEyVDIwOjU5OjQzLjcwMloiLCJwdXIiOiJibG9iX2tleSJ9fQ==--1268d7dfb19428abd6d104f0b1ce526e5cfbca8e/GM_job_newsletter_ad.pdf?content_type=application%2Fpdf&disposition=inline%3B+filename%3D%22GM_job_newsletter_ad.pdf%22%3B+filename%2A%3DUTF-8%27%27GM_job_newsletter_ad.pdf"
    flash[:alert] = %Q[We're hiring for the position of <strong><a href="#{file_link}">General Manager</a></strong> at the hub!].html_safe
  end

  def newsletters
    @campaigns = Mailchimp::Api.get_campaigns["campaigns"].sort_by{ |c| c["send_time"] }.reverse
  end

  def questions
    @faq_groups = FaqGroup.preload(:faqs)
  end
end
