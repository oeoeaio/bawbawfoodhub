class RolloverPolicy < ApplicationPolicy
  def admin_create_multiple?
    user.class == Admin
  end
end
