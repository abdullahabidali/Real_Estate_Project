class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      can :read, Property
      can :create, Property
      can [:update, :destroy], Property, user_id: user.id

      # Users can manage their own favorites
      can :manage, Favorite, user_id: user.id

      # Users can manage their own messages
      can :manage, Message, sender_id: user.id
      can :read, Message, receiver_id: user.id

      # Users can manage their own profile
      can :manage, User, id: user.id
    end
  end
end 