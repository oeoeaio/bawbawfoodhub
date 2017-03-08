class AlertPolicy < ApplicationPolicy
  def admin_sleep?
    user.class == Admin
  end
end
