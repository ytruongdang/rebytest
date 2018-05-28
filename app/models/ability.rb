class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.is_admin?
      can :manage, User
      can [:read, :create, :destroy], Comment
      can [:update], Comment do |comment|
        comment.user == user
      end
      can [:read], Review
      can [:read, :update], Booking
      can :manage, Place
      can :manage, Tour
      can :manage, Category
      can [:read, :destroy], Review
    else
      can :read, User do |u|
        u == user
      end
      can [:read, :create], Comment
      can [:update, :destroy], Comment do |comment|
        comment.user == user
      end
      can [:read, :create], Review
      can [:update, :destroy], Review do |review|
        review.user == user
      end
      can :manage, Like
      can [:new, :create], Booking
      can [:read, :update], Booking do |booking|
        booking.user == user
      end
    end
  end
end
