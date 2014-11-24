module ApplicationHelper
  def first_error_for(target, field)
    if target.errors[field].any?
      render 'shared/field_error', target: target, field: field
    end
  end
end
