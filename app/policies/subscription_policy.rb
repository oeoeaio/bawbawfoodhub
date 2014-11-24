class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.class == Admin
        scope.all
      elsif user.class == User
        scope.where(user: user)
      end
    end
  end
end