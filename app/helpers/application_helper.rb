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
end
