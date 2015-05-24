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

  def icon_class(label)
    case label
    when "About"
      'fa fa-users'
    when "Local Food"
      'bbfh-eggplant'
    when "Get Involved"
      'fa fa-exchange'
    when "Resources"
      'fa fa-book'
    when "Producers"
      'bbfh-producer'
    else
      ''
    end
  end

  def producer_pages
    @cms_site.pages.find_by_full_path('/producers').children.
    published.where("label != 'Summary'")
  end
end
