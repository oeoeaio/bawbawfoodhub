class SeasonPolicy < ApplicationPolicy
  def admin_populate?
    user.class == Admin
  end
end
