class RolloverPolicy < ApplicationPolicy
  def admin_new_multiple?
    user.class == Admin
  end

  def admin_create_multiple?
    admin_new_multiple?
  end

  def admin_new_multiple_from_csv?
    user.class == Admin
  end

  def admin_create_multiple_from_csv?
    admin_new_multiple_from_csv?
  end

  def admin_bulk_action?
    user.class == Admin
  end
end
