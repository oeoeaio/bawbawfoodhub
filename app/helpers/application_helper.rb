module ApplicationHelper
  def error_class(target, field)
    target.errors[field].any? ? "error": ""
  end

  def first_error_for(target, field)
    if target.errors[field].any?
      render 'shared/field_error', target: target, field: field
    end
  end
end
