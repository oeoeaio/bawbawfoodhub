module ApplicationHelper
  def error_class(target, field)
    target.errors[field].any? ? "error": ""
  end

  def first_error_for(target, field)
    if target.errors[field].any?
      render 'shared/field_error', target: target, field: field
    end
  end

  def readable_date(date)
    date.strftime("#{date.day.ordinalize} of %B")
  end

  def current_season
    season = Season.all.where(signups_open: true)
    .select{ |season| season.first_pack_day_with_lead_time_after(Time.now).present? }
    .sort{ |a,b| a.first_pack_day.pack_date <=> b.first_pack_day.pack_date }.first

    season || Season.order(created_at: :desc).limit(1).last
  end

  def root_path?
    request.path == root_path
  end

  def cms_page(slug)
    return unless @cms_site.present?
    @cms_site.pages.published.find_by(slug: slug)
  end

  def producer_pages
    @cms_site.pages.find_by_full_path('/producers').children.
    published.where("label != 'Summary'")
  end

  def recaptcha_field
    hidden_field_tag(:recaptcha_token, '', 'data-target': 'recaptcha.token')
  end
end
