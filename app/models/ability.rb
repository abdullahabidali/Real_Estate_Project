class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      # All users can read properties
      can :read, Property
      
      # Only sellers can create, update and destroy properties
      if user.seller?
        can :create, Property
        can [:update, :destroy], Property, user_id: user.id
      end

      # Users can manage their own favorites
      can :manage, Favorite, user_id: user.id

      # Users can manage their own messages
      can :manage, Message, user_id: user.id

      # Users can view any profile but only manage their own
      can :read, User
      can :manage, User, id: user.id

      # Users can manage their own comments
      can :manage, PropertyComment, user_id: user.id
      can :read, PropertyComment

      # Users can create reviews and manage their own reviews
      can :create, Review
      can :manage, Review, user_id: user.id
      can :read, Review
    end
  end
end 