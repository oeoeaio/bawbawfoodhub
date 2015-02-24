class RolloverPolicy < ApplicationPolicy
  def admin_new_multiple?
    user.class == Admin
  end

  def admin_create_multiple?
    admin_new_multiple?
  end
end
