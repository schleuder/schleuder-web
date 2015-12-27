class Ability
  include CanCan::Ability
  def initialize(account)
    account ||= Account.new
    if account.superadmin?
      can :manage, :all
    else
      # Setup+Create accounts
      can [:create, :verify, :setup], Account
      # Own account
      can [:read, :update, :destroy], Account, id: account.id
      # Own subscriptions
      can [:read, :update, :destroy], Subscription, email: account.email
      # All subscriptions of lists it admins
      can :manage, Subscription, list_id: account.lists.map(&:id)
      # Lists subscribed to
      can [:read], List, id: account.subscriptions.map(&:list).map(&:id)
      # Lists it admins
      can [:read, :update], List, id: account.admin_lists.map(&:id)
    end
  end
end

