class AdminAbility
  include CanCan::Ability

  def initialize(admin_user)
    return unless admin_user

    # Admin can manage all resources
    can :manage, :all
  end
end 