class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :access, :admin

    can :manage, Effective::Asset, user_id: user.id
    can :manage, Effective::Cart, user_id: user.id
    can :manage, Effective::Order, user_id: user.id # Orders cannot be deleted
    can :manage, Effective::Subscription, user_id: user.id # We don't use subscriptions in this app

    can :show, Effective::Page do |page| page.roles_permit?(user) end
    can [:index, :show], Effective::Post
    can :show, Effective::StyleGuide
    can :index, Effective::Datatables::StyleGuide

    can [:edit, :update], User, id: user.id

    if user.is?(:member)
    end

    if user.is?(:admin)
      can :access, :admin

      can :manage, Effective::Asset
      can :manage, Effective::Log
      can :manage, Effective::Menu
      can :manage, Effective::Page
      can :manage, Effective::Post
      can :manage, Effective::Region

      can :manage, User

      # Effective Orders has a few more permissions
      can :manage, Effective::Order
      can :manage, Effective::Customer
      can :show, :payment_details # Can see the payment purchase details on orders

      can :admin, :effective_logging
      can :admin, :effective_orders
      can :admin, :effective_pages
      can :admin, :effective_posts
      can :admin, :effective_roles
    end

  end
end